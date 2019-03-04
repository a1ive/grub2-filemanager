# Copyright (c) 2015, Intel Corporation
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#     * Neither the name of Intel Corporation nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""efi module."""

from __future__ import print_function
from cStringIO import StringIO
from _ctypes import CFuncPtr as _CFuncPtr
import _efi
import atexit
import binascii
import bits
import bits.cdata
from collections import OrderedDict
from ctypes import *
from efikeys import *
import redirect
import os
import sys as _sys
import traceback
import uuid

known_uuids = {
    uuid.UUID('00720665-67eb-4a99-baf7-d3c33a1c7cc9'): 'EFI_TCP4_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('02e800be-8f01-4aa6-946b-d71388e1833f'): 'EFI_MTFTP4_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('0379be4e-d706-437d-b037-edb82fb772a4'): 'EFI_DEVICE_PATH_UTILITIES_PROTOCOL_GUID',
    uuid.UUID('03c4e603-ac28-11d3-9a2d-0090273fc14d'): 'EFI_PXE_BASE_CODE_PROTOCOL_GUID',
    uuid.UUID('05ad34ba-6f02-4214-952e-4da0398e2bb9'): 'EFI_DXE_SERVICES_TABLE_GUID',
    uuid.UUID('09576e91-6d3f-11d2-8e39-00a0c969723b'): 'EFI_DEVICE_PATH_PROTOCOL_GUID',
    uuid.UUID('09576e92-6d3f-11d2-8e39-00a0c969723b'): 'EFI_FILE_INFO_ID',
    uuid.UUID('09576e93-6d3f-11d2-8e39-00a0c969723b'): 'EFI_FILE_SYSTEM_INFO_ID',
    uuid.UUID('0db48a36-4e54-ea9c-9b09-1ea5be3a660b'): 'EFI_REST_PROTOCOL_GUID',
    uuid.UUID('0faaecb1-226e-4782-aace-7db9bcbf4daf'): 'EFI_FTP4_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('107a772c-d5e1-11d4-9a46-0090273fc14d'): 'EFI_COMPONENT_NAME_PROTOCOL_GUID',
    uuid.UUID('11b34006-d85b-4d0a-a290-d5a571310ef7'): 'PCD_PROTOCOL_GUID',
    uuid.UUID('13a3f0f6-264a-3ef0-f2e0-dec512342f34'): 'EFI_PCD_PROTOCOL_GUID',
    uuid.UUID('13ac6dd1-73d0-11d4-b06b-00aa00bd6de7'): 'EFI_EBC_INTERPRETER_PROTOCOL_GUID',
    uuid.UUID('143b7632-b81b-4cb7-abd3-b625a5b9bffe'): 'EFI_EXT_SCSI_PASS_THRU_PROTOCOL_GUID',
    uuid.UUID('151c8eae-7f2c-472c-9e54-9828194f6a88'): 'EFI_DISK_IO2_PROTOCOL_GUID',
    uuid.UUID('1682fe44-bd7a-4407-b7c7-dca37ca3922d'): 'EFI_TLS_CONFIGURATION_PROTOCOL_GUID',
    uuid.UUID('18a031ab-b443-4d1a-a5c0-0c09261e9f71'): 'EFI_DRIVER_BINDING_PROTOCOL_GUID',
    uuid.UUID('1c0c34f6-d380-41fa-a049-8ad06c1a66aa'): 'EFI_EDID_DISCOVERED_PROTOCOL_GUID',
    uuid.UUID('1d3de7f0-0807-424f-aa69-11a54e19a46f'): 'EFI_ATA_PASS_THRU_PROTOCOL_GUID',
    uuid.UUID('2755590c-6f3c-42fa-9ea4-a3ba543cda25'): 'EFI_DEBUG_SUPPORT_PROTOCOL_GUID',
    uuid.UUID('2a534210-9280-41d8-ae79-cada01a2b127'): 'EFI_DRIVER_HEALTH_PROTOCOL_GUID',
    uuid.UUID('2c8759d5-5c2d-66ef-925f-b66c101957e2'): 'EFI_IP6_PROTOCOL_GUID',
    uuid.UUID('2f707ebb-4a1a-11d4-9a38-0090273fc14d'): 'EFI_PCI_ROOT_BRIDGE_IO_PROTOCOL_GUID',
    uuid.UUID('31878c87-0b75-11d5-9a4f-0090273fc14d'): 'EFI_SIMPLE_POINTER_PROTOCOL_GUID',
    uuid.UUID('31a6406a-6bdf-4e46-b2a2-ebaa89c40920'): 'EFI_HII_IMAGE_PROTOCOL_GUID',
    uuid.UUID('330d4706-f2a0-4e4f-a369-b66fa8d54385'): 'EFI_HII_CONFIG_ACCESS_PROTOCOL_GUID',
    uuid.UUID('387477c1-69c7-11d2-8e39-00a0c969723b'): 'EFI_SIMPLE_TEXT_INPUT_PROTOCOL_GUID',
    uuid.UUID('387477c2-69c7-11d2-8e39-00a0c969723b'): 'EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL_GUID',
    uuid.UUID('39b68c46-f7fb-441b-b6ec-16b0f69821f3'): 'EFI_CAPSULE_REPORT_GUID',
    uuid.UUID('3ad9df29-4501-478d-b1f8-7f7fe70e50f3'): 'EFI_UDP4_PROTOCOL_GUID',
    uuid.UUID('3b95aa31-3793-434b-8667-c8070892e05e'): 'EFI_IP4_CONFIG_PROTOCOL_GUID',
    uuid.UUID('3e35c163-4074-45dd-431e-23989dd86b32'): 'EFI_HTTP_UTILITIES_PROTOCOL_GUID',
    uuid.UUID('3e745226-9818-45b6-a2ac-d7cd0e8ba2bc'): 'EFI_USB2_HC_PROTOCOL_GUID',
    uuid.UUID('41d94cd2-35b6-455a-8258-d4e51334aadd'): 'EFI_IP4_PROTOCOL_GUID',
    uuid.UUID('49152e77-1ada-4764-b7a2-7afefed95e8b'): 'EFI_DEBUG_IMAGE_INFO_TABLE_GUID',
    uuid.UUID('4c19049f-4137-4dd3-9c10-8b97a83ffdfa'): 'EFI_MEMORY_TYPE_INFORMATION_GUID',
    uuid.UUID('4cf5b200-68b8-4ca5-9eec-b23e3f50029a'): 'EFI_PCI_IO_PROTOCOL_GUID',
    uuid.UUID('4d330321-025f-4aac-90d8-5ed900173b63'): 'EFI_DRIVER_DIAGNOSTICS_PROTOCOL_GUID',
    uuid.UUID('4f948815-b4b9-43cb-8a33-90e060b34955'): 'EFI_UDP6_PROTOCOL_GUID',
    uuid.UUID('587e72d7-cc50-4f79-8209-ca291fc1a10f'): 'EFI_HII_CONFIG_ROUTING_PROTOCOL_GUID',
    uuid.UUID('59324945-ec44-4c0d-b1cd-9db139df070c'): 'EFI_ISCSI_INITIATOR_NAME_PROTOCOL_GUID',
    uuid.UUID('5b1b31a1-9562-11d2-8e3f-00a0c969723b'): 'EFI_LOADED_IMAGE_PROTOCOL_GUID',
    uuid.UUID('5b446ed1-e30b-4faa-871a-3654eca36080'): 'EFI_IP4_CONFIG2_PROTOCOL_GUID',
    uuid.UUID('5c198761-16a8-4e69-972c-89d67954f81d'): 'EFI_DRIVER_SUPPORTED_EFI_VERSION_PROTOCOL_GUID',
    uuid.UUID('65530bc7-a359-410f-b010-5aadc7ec2b62'): 'EFI_TCP4_PROTOCOL_GUID',
    uuid.UUID('66ed4721-3c98-4d3e-81e3-d03dd39a7254'): 'EFI_UDP6_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('6a1ee763-d47a-43b4-aabe-ef1de2ab56fc'): 'EFI_HII_PACKAGE_LIST_PROTOCOL_GUID',
    uuid.UUID('6a7a5cff-e8d9-4f70-bada-75ab3025ce14'): 'EFI_COMPONENT_NAME2_PROTOCOL_GUID',
    uuid.UUID('6b30c738-a391-11d4-9a3b-0090273fc14d'): 'EFI_PLATFORM_DRIVER_OVERRIDE_PROTOCOL_GUID',
    uuid.UUID('7739f24c-93d7-11d4-9a3a-0090273fc14d'): 'EFI_HOB_LIST_GUID',
    uuid.UUID('78247c57-63db-4708-99c2-a8b4a9a61f6b'): 'EFI_MTFTP4_PROTOCOL_GUID',
    uuid.UUID('783658a3-4172-4421-a299-e009079c0cb4'): 'EFI_LEGACY_BIOS_PLATFORM_PROTOCOL_GUID',
    uuid.UUID('7a59b29b-910b-4171-8242-a85a0df25b5b'): 'EFI_HTTP_PROTOCOL_GUID',
    uuid.UUID('7ab33a91-ace5-4326-b572-e7ee33d39f16'): 'EFI_MANAGED_NETWORK_PROTOCOL_GUID',
    uuid.UUID('7f1647c8-b76e-44b2-a565-f70ff19cd19e'): 'EFI_DNS6_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('83f01464-99bd-45e5-b383-af6305d8e9e6'): 'EFI_UDP4_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('87c8bad7-0595-4053-8297-dede395f5d5b'): 'EFI_DHCP6_PROTOCOL_GUID',
    uuid.UUID('8868e871-e4f1-11d3-bc22-0080c73c8881'): 'EFI_ACPI_TABLE_GUID',
    uuid.UUID('8a219718-4ef5-4761-91c8-c0f04bda9e56'): 'EFI_DHCP4_PROTOCOL_GUID',
    uuid.UUID('8b843e20-8132-4852-90cc-551a4e4a7f1c'): 'EFI_DEVICE_PATH_TO_TEXT_PROTOCOL_GUID',
    uuid.UUID('8d59d32b-c655-4ae9-9b15-f25904992a43'): 'EFI_ABSOLUTE_POINTER_PROTOCOL_GUID',
    uuid.UUID('9042a9de-23dc-4a38-96fb-7aded080516a'): 'EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID',
    uuid.UUID('937fe521-95ae-4d1a-8929-48bcd90ad31a'): 'EFI_IP6_CONFIG_PROTOCOL_GUID',
    uuid.UUID('952cb795-ff36-48cf-a249-4df486d6ab8d'): 'EFI_TLS_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('964e5b21-6459-11d2-8e39-00a0c969723b'): 'EFI_BLOCK_IO_PROTOCOL_GUID',
    uuid.UUID('964e5b22-6459-11d2-8e39-00a0c969723b'): 'EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_GUID',
    uuid.UUID('9d9a39d8-bd42-4a73-a4d5-8ee94be11380'): 'EFI_DHCP4_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('9e23d768-d2f3-4366-9fc3-3a7aba864374'): 'EFI_VLAN_CONFIG_PROTOCOL_GUID',
    uuid.UUID('9fb9a8a1-2f4a-43a6-889c-d0f7b6c47ad5'): 'EFI_DHCP6_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('a3979e64-ace8-4ddc-bc07-4d66b8fd0977'): 'EFI_IPSEC2_PROTOCOL_GUID',
    uuid.UUID('a4c751fc-23ae-4c3e-92e9-4964cf63f349'): 'EFI_UNICODE_COLLATION_PROTOCOL2_GUID',
    uuid.UUID('a77b2472-e282-4e9f-a245-c2c0e27bbcc1'): 'EFI_BLOCK_IO2_PROTOCOL_GUID',
    uuid.UUID('ae3d28cc-e05b-4fa1-a011-7eb55a3f1401'): 'EFI_DNS4_PROTOCOL_GUID',
    uuid.UUID('b625b186-e063-44f7-8905-6a74dc6f52b4'): 'EFI_DNS4_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('b9d4c360-bcfb-4f9b-9298-53c136982258'): 'EFI_FORM_BROWSER2_PROTOCOL_GUID',
    uuid.UUID('bb25cf6f-f1d4-11d2-9a0c-0090273fc1fd'): 'EFI_SERIAL_IO_PROTOCOL_GUID',
    uuid.UUID('bc62157e-3e33-4fec-9920-2d3b36d750df'): 'EFI_LOADED_IMAGE_DEVICE_PATH_PROTOCOL_GUID',
    uuid.UUID('bd8c1056-9f36-44ec-92a8-a6337f817986'): 'EFI_EDID_ACTIVE_PROTOCOL_GUID',
    uuid.UUID('bdc8e6af-d9bc-4379-a72a-e0c4e75dae1c'): 'EFI_HTTP_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('bf0a78ba-ec29-49cf-a1c9-7ae54eab6a51'): 'EFI_MTFTP6_PROTOCOL_GUID',
    uuid.UUID('c51711e7-b4bf-404a-bfb8-0a048ef1ffe4'): 'EFI_IP4_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('c68ed8e2-9dc6-4cbd-9d94-db65acc5c332'): 'EFI_SMM_COMMUNICATION_PROTOCOL_GUID',
    uuid.UUID('ca37bc1f-a327-4ae9-828a-8c40d8506a17'): 'EFI_DNS6_PROTOCOL_GUID',
    uuid.UUID('ce345171-ba0b-11d2-8e4f-00a0c969723b'): 'EFI_DISK_IO_PROTOCOL_GUID',
    uuid.UUID('ce5e5929-c7a3-4602-ad9e-c9daf94ebfcf'): 'EFI_IPSEC_CONFIG_PROTOCOL_GUID',
    uuid.UUID('d42ae6bd-1352-4bfb-909a-ca72a6eae889'): 'LZMAF86_CUSTOM_DECOMPRESS_GUID',
    uuid.UUID('d8117cfe-94a6-11d4-9a3a-0090273fc14d'): 'EFI_DECOMPRESS_PROTOCOL_GUID',
    uuid.UUID('d9760ff3-3cca-4267-80f9-7527fafa4223'): 'EFI_MTFTP6_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('db47d7d3-fe81-11d3-9a35-0090273fc14d'): 'EFI_FILE_SYSTEM_VOLUME_LABEL_ID',
    uuid.UUID('dd9e7534-7762-4698-8c14-f58517a625aa'): 'EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL_GUID',
    uuid.UUID('dfb386f7-e100-43ad-9c9a-ed90d08a5e12'): 'EFI_IPSEC_PROTOCOL_GUID',
    uuid.UUID('e9ca4775-8657-47fc-97e7-7ed65a084324'): 'EFI_HII_FONT_PROTOCOL_GUID',
    uuid.UUID('eb338826-681b-4295-b356-2b364c757b09'): 'EFI_FTP4_PROTOCOL_GUID',
    uuid.UUID('eb9d2d2f-2d88-11d3-9a16-0090273fc14d'): 'MPS_TABLE_GUID',
    uuid.UUID('eb9d2d30-2d88-11d3-9a16-0090273fc14d'): 'ACPI_TABLE_GUID',
    uuid.UUID('eb9d2d31-2d88-11d3-9a16-0090273fc14d'): 'SMBIOS_TABLE_GUID',
    uuid.UUID('eb9d2d32-2d88-11d3-9a16-0090273fc14d'): 'SAL_SYSTEM_TABLE_GUID',
    uuid.UUID('eba4e8d2-3858-41ec-a281-2647ba9660d0'): 'EFI_DEBUGPORT_PROTOCOL_GUID',
    uuid.UUID('ec20eb79-6c1a-4664-9a0d-d2e4cc16d664'): 'EFI_TCP6_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('ec835dd3-fe0f-617b-a621-b350c3e13388'): 'EFI_IP6_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('ee4e5898-3914-4259-9d6e-dc7bd79403cf'): 'LZMA_CUSTOM_DECOMPRESS_GUID',
    uuid.UUID('ef9fc172-a1b2-4693-b327-6d32fc416042'): 'EFI_HII_DATABASE_PROTOCOL_GUID',
    uuid.UUID('f2fd1544-9794-4a2c-992e-e5bbcf20e394'): 'SMBIOS3_TABLE_GUID',
    uuid.UUID('f36ff770-a7e1-42cf-9ed2-56f0f271f44c'): 'EFI_MANAGED_NETWORK_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('f44c00ee-1f2c-4a00-aa09-1c9f3e0800a3'): 'EFI_ARP_SERVICE_BINDING_PROTOCOL_GUID',
    uuid.UUID('f4b427bb-ba21-4f16-bc4e-43e416ab619c'): 'EFI_ARP_PROTOCOL_GUID',
    uuid.UUID('f4ccbfb7-f6e0-47fd-9dd4-10a8f150c191'): 'EFI_SMM_BASE2_PROTOCOL_GUID',
    uuid.UUID('f541796d-a62e-4954-a775-9584f61b9cdd'): 'EFI_TCG_PROTOCOL_GUID',
    uuid.UUID('fc1bcdb0-7d31-49aa-936a-a4600d9dd083'): 'EFI_CRC32_GUIDED_SECTION_EXTRACTION_GUID',
    uuid.UUID('ffe06bdd-6107-46a6-7bb2-5a9c7ec5275c'): 'EFI_ACPI_TABLE_PROTOCOL_GUID',
}

# Create each of the values above as a constant referring to the corresponding UUID.
globals().update(map(reversed, known_uuids.iteritems()))

class Protocol(bits.cdata.Struct):
    """Base class for EFI protocols. Derived classes must have a uuid.UUID named guid."""
    @classmethod
    def from_handle(cls, handle):
        """Retrieve an instance of this protocol from an EFI handle"""
        p = cls.from_address(get_protocol(handle, cls.guid))
        p._handle = handle
        return p

ptrsize = sizeof(c_void_p)

if ptrsize == 4:
    EFIFUNCTYPE = CFUNCTYPE
else:
    _efi_functype_cache = {}
    def EFIFUNCTYPE(restype, *argtypes):
        """EFIFUNCTYPE(restype, *argtypes) -> function prototype.

        restype: the result type
        argtypes: a sequence specifying the argument types

        The function prototype can be called in different ways to create a
        callable object:

        prototype(integer address) -> foreign function
        prototype(callable) -> create and return a C callable function from callable
        """
        try:
            return _efi_functype_cache[(restype, argtypes)]
        except KeyError:
            class CFunctionType(_CFuncPtr):
                _argtypes_ = argtypes
                _restype_ = restype
                _flags_ = 0
            _efi_functype_cache[(restype, argtypes)] = CFunctionType
            return CFunctionType

# Define UEFI data types
BOOLEAN = c_bool
CHAR8 = c_char
CHAR16 = c_wchar
EFI_BROWSER_ACTION = c_ulong
EFI_BROWSER_ACTION_REQUEST = c_ulong
EFI_EVENT = c_void_p
EFI_GUID = bits.cdata.GUID
EFI_HANDLE = c_void_p
EFI_HII_DATABASE_NOTIFY_TYPE = c_ulong
EFI_HII_HANDLE = c_void_p
EFI_INTERFACE_TYPE = c_ulong
EFI_KEY = c_ulong
EFI_LOCATE_SEARCH_TYPE = c_ulong
EFI_MEMORY_TYPE = c_ulong
EFI_PHYSICAL_ADDRESS = c_uint64
EFI_QUESTION_ID = c_uint16
EFI_STATUS = c_ulong
EFI_STRING = c_wchar_p
EFI_STRING_ID = c_uint16
EFI_TIMER_DELAY = c_ulong
EFI_TPL = c_ulong
EFI_VIRTUAL_ADDRESS = c_uint64
INT8 = c_int8
INT16 = c_int16
INT32 = c_int32
INT64 = c_int64
UINTN = c_ulong
UINT8 = c_uint8
UINT16 = c_uint16
UINT32 = c_uint32
UINT64 = c_uint64

def FUNC(*argtypes, **kw):
    """FUNC(*argtypes, ret=EFI_STATUS) -> function prototype.

    ret: the result type (defaults to EFI_STATUS)
    argtypes: a sequence specifying the argument types

    The function prototype can be called in different ways to create a
    callable object:

    prototype(integer address) -> foreign function
    prototype(callable) -> create and return a C callable function from callable
    """
    ret = kw.pop("ret", EFI_STATUS)
    if kw:
        raise TypeError("Invalid keyword arguments")
    return EFIFUNCTYPE(ret, *argtypes)

def compute_crc(buf, offset):
    before_buffer = (UINT8 * offset).from_buffer(buf)
    zero = (UINT8 * 4)()
    after_buffer = (UINT8 * (sizeof(buf) - offset - 4)).from_buffer(buf, offset + 4)
    crc = binascii.crc32(before_buffer)
    crc = binascii.crc32(zero, crc)
    return binascii.crc32(after_buffer, crc)

def table_crc(table):
    th = TableHeader.from_buffer(table)
    buf = (UINT8 * th.HeaderSize).from_buffer(table)
    crc = compute_crc(buf, TableHeader.CRC32.offset)
    return th.CRC32 == c_uint32(crc).value

class EFI_DEVICE_PATH_PROTOCOL(Protocol):
    guid = EFI_DEVICE_PATH_PROTOCOL_GUID
    _fields_ = [
        ("Type", UINT8),
        ("SubType", UINT8),
        ("Length", UINT8 * 2),
    ]

class EFI_DEVICE_PATH_TO_TEXT_PROTOCOL(Protocol):
    guid = EFI_DEVICE_PATH_TO_TEXT_PROTOCOL_GUID
    _fields_ = [
        ("ConvertDeviceNodeToText", FUNC(POINTER(EFI_DEVICE_PATH_PROTOCOL), BOOLEAN, BOOLEAN, ret=POINTER(CHAR16))),
        ("ConvertDevicePathToText", FUNC(POINTER(EFI_DEVICE_PATH_PROTOCOL), BOOLEAN, BOOLEAN, ret=POINTER(CHAR16))),
    ]

    def _helper(self, method, path):
        ucs2_string_ptr = method(path, 0, 0)
        try:
            s = wstring_at(ucs2_string_ptr)
        finally:
            check_status(system_table.BootServices.contents.FreePool(ucs2_string_ptr))
        return s

    def device_path_text(self, path):
        """Convert the specified device path to text."""
        return self._helper(self.ConvertDevicePathToText, path)

    def device_node_text(self, path):
        """Convert the specified device node to text."""
        return self._helper(self.ConvertDeviceNodeToText, path)

class EFI_HII_TIME(bits.cdata.Struct):
    _fields_ = [
        ('Hour', UINT8),
        ('Minute', UINT8),
        ('Second', UINT8),
    ]

class EFI_HII_DATE(bits.cdata.Struct):
    _fields_ = [
        ('Year', UINT16),
        ('Month', UINT8),
        ('Day', UINT8),
    ]

class EFI_IFR_TYPE_VALUE(bits.cdata.Union):
    _fields_ = [
        ('u8', UINT8),
        ('u16', UINT16),
        ('u32', UINT32),
        ('u64', UINT64),
        ('b', BOOLEAN),
        ('time', EFI_HII_TIME),
        ('date', EFI_HII_DATE),
        ('string', EFI_STRING_ID),
    ]

class EFI_HII_CONFIG_ACCESS_PROTOCOL(Protocol):
    """EFI HII Configuration Access Protocol"""
    guid = EFI_HII_CONFIG_ACCESS_PROTOCOL_GUID

EFI_HII_CONFIG_ACCESS_PROTOCOL._fields_ = [
    ('ExtractConfig', FUNC(POINTER(EFI_HII_CONFIG_ACCESS_PROTOCOL), EFI_STRING, POINTER(EFI_STRING), POINTER(EFI_STRING))),
    ('RouteConfig', FUNC(POINTER(EFI_HII_CONFIG_ACCESS_PROTOCOL), EFI_STRING, POINTER(EFI_STRING))),
    ('Callback', FUNC(POINTER(EFI_HII_CONFIG_ACCESS_PROTOCOL), EFI_BROWSER_ACTION, EFI_QUESTION_ID, UINT8, POINTER(EFI_IFR_TYPE_VALUE), POINTER(EFI_BROWSER_ACTION_REQUEST))),
]

class EFI_HII_CONFIG_ROUTING_PROTOCOL(Protocol):
    """EFI HII Configuration Routing Protocol"""
    guid = EFI_HII_CONFIG_ROUTING_PROTOCOL_GUID

EFI_HII_CONFIG_ROUTING_PROTOCOL._fields_ = [
    ('ExtractConfig', FUNC(POINTER(EFI_HII_CONFIG_ROUTING_PROTOCOL), EFI_STRING, POINTER(EFI_STRING), POINTER(EFI_STRING))),
    ('ExportConfig', FUNC(POINTER(EFI_HII_CONFIG_ROUTING_PROTOCOL), POINTER(EFI_STRING))),
    ('RouteConfig', FUNC(POINTER(EFI_HII_CONFIG_ROUTING_PROTOCOL), EFI_STRING, POINTER(EFI_STRING))),
    ('BlockToConfig', FUNC(POINTER(EFI_HII_CONFIG_ROUTING_PROTOCOL), EFI_STRING, POINTER(UINT8), UINTN, POINTER(EFI_STRING), POINTER(EFI_STRING))),
    ('ConfigToBlock', FUNC(POINTER(EFI_HII_CONFIG_ROUTING_PROTOCOL), POINTER(EFI_STRING), POINTER(UINT8), POINTER(UINTN), POINTER(EFI_STRING))),
    ('GetAltConfig', FUNC(POINTER(EFI_HII_CONFIG_ROUTING_PROTOCOL), EFI_STRING, POINTER(EFI_GUID), EFI_STRING, POINTER(EFI_DEVICE_PATH_PROTOCOL), EFI_STRING, POINTER(EFI_STRING))),
]

class EFI_HII_PACKAGE_LIST_HEADER(bits.cdata.Struct):
    _fields_ = [
        ('PackageListGuid', EFI_GUID),
        ('PackagLength', UINT32),
    ]

class EFI_KEY_DESCRIPTOR(bits.cdata.Struct):
    _fields_ = [
        ('Key', EFI_KEY),
        ('Unicode', CHAR16),
        ('ShiftedUnicode', CHAR16),
        ('AltGrUnicode', CHAR16),
        ('ShiftedAltGrUnicode', CHAR16),
        ('Modifier', UINT16),
        ('AffectedAttribute', UINT16),
    ]

class EFI_HII_KEYBOARD_LAYOUT(bits.cdata.Struct):
    _fields_ = [
        ('LayoutLength', UINT16),
        ('Guid', EFI_GUID),
        ('LayoutDescriptorStringOffset', UINT32),
        ('DescriptorCount', UINT8),
        ('Descriptors', POINTER(EFI_KEY_DESCRIPTOR)),
    ]

class EFI_HII_DATABASE_PROTOCOL(Protocol):
    """EFI HII Database Protocol"""
    guid = EFI_HII_DATABASE_PROTOCOL_GUID

EFI_HII_DATABASE_PROTOCOL._fields_ = [
    ('NewPackageList', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), POINTER(EFI_HII_PACKAGE_LIST_HEADER), EFI_HANDLE, POINTER(EFI_HANDLE))),
    ('RemovePackageList', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), EFI_HII_HANDLE)),
    ('UpdatePackageList', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), EFI_HII_HANDLE, POINTER(EFI_HII_PACKAGE_LIST_HEADER))),
    ('ListPackageLists', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), UINT8, POINTER(EFI_GUID), POINTER(UINTN), POINTER(EFI_HII_HANDLE))),
    ('ExportPackageLists', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), EFI_HII_HANDLE, POINTER(UINTN), POINTER(EFI_HII_PACKAGE_LIST_HEADER))),
    ('RegisterPackageNotify', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), UINT8, POINTER(EFI_GUID), EFI_HII_DATABASE_NOTIFY_TYPE, POINTER(EFI_HANDLE))),
    ('UnregisterPackageNotify', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), EFI_HANDLE)),
    ('FindKeyboardsLayouts', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), POINTER(UINT16))),
    ('GetKeyboardLayouts', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), POINTER(EFI_GUID), POINTER(UINT16), POINTER(EFI_HII_KEYBOARD_LAYOUT))),
    ('SetKeyboardLayout', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), POINTER(EFI_GUID))),
    ('GetPackageListHandle', FUNC(POINTER(EFI_HII_DATABASE_PROTOCOL), EFI_HII_HANDLE, POINTER(EFI_HANDLE))),
]

class EFI_INPUT_KEY(bits.cdata.Struct):
    _fields_ = [
        ("ScanCode", UINT16),
        ("UnicodeChar", CHAR16),
    ]

class EFI_SIMPLE_TEXT_INPUT_PROTOCOL(Protocol):
    """EFI Simple Text Input Protocol"""
    guid = EFI_SIMPLE_TEXT_INPUT_PROTOCOL_GUID

EFI_SIMPLE_TEXT_INPUT_PROTOCOL._fields_ = [
    ('Reset', FUNC(POINTER(EFI_SIMPLE_TEXT_INPUT_PROTOCOL), BOOLEAN)),
    ('ReadKeyStroke', FUNC(POINTER(EFI_SIMPLE_TEXT_INPUT_PROTOCOL), POINTER(EFI_INPUT_KEY))),
    ('WaitForKey', EFI_EVENT),
]

EFI_SHIFT_STATE_VALID     = 0x80000000
EFI_RIGHT_SHIFT_PRESSED   = 0x00000001
EFI_LEFT_SHIFT_PRESSED    = 0x00000002
EFI_RIGHT_CONTROL_PRESSED = 0x00000004
EFI_LEFT_CONTROL_PRESSED  = 0x00000008
EFI_RIGHT_ALT_PRESSED     = 0x00000010
EFI_LEFT_ALT_PRESSED      = 0x00000020
EFI_RIGHT_LOGO_PRESSED    = 0x00000040
EFI_LEFT_LOGO_PRESSED     = 0x00000080
EFI_MENU_KEY_PRESSED      = 0x00000100
EFI_SYS_REQ_PRESSED       = 0x00000200

EFI_KEY_TOGGLE_STATE   = UINT8
EFI_TOGGLE_STATE_VALID = 0x80
EFI_KEY_STATE_EXPOSED  = 0x40
EFI_SCROLL_LOCK_ACTIVE = 0x01
EFI_NUM_LOCK_ACTIVE    = 0x02
EFI_CAPS_LOCK_ACTIVE   = 0x04

class EFI_KEY_STATE(bits.cdata.Struct):
    _fields_ = [
        ("KeyShiftState", UINT32),
        ("KeyToggleState", EFI_KEY_TOGGLE_STATE),
    ]

class EFI_KEY_DATA(bits.cdata.Struct):
    _fields_ = [
        ("Key", EFI_INPUT_KEY),
        ("KeyState", EFI_KEY_STATE),
    ]

EFI_KEY_NOTIFY_FUNCTION = FUNC(POINTER(EFI_KEY_DATA))

class EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL(Protocol):
    """EFI Simple Text Input Ex Protocol"""
    guid = EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL_GUID

EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL._fields_ = [
    ('Reset', FUNC(POINTER(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL), BOOLEAN)),
    ('ReadKeyStrokeEx', FUNC(POINTER(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL), POINTER(EFI_KEY_DATA))),
    ('WaitForKeyEx', EFI_EVENT),
    ('SetState', FUNC(POINTER(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL), POINTER(EFI_KEY_TOGGLE_STATE))),
    ('RegisterKeyNotify', FUNC(POINTER(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL), POINTER(EFI_KEY_DATA), EFI_KEY_NOTIFY_FUNCTION, POINTER(c_void_p))),
    ('UnregisterKeyNotify', FUNC(POINTER(EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL), c_void_p)),
]

class SIMPLE_TEXT_OUTPUT_MODE(bits.cdata.Struct):
    """Decode the SIMPLE_TEXT_OUTPUT_MODE structure"""
    _fields_ = [
        ('MaxMode', INT32),
        ('Mode', INT32),
        ('Attribute', INT32),
        ('CursorColumn', INT32),
        ('CursorRow', INT32),
        ('CursorVisible', BOOLEAN),
    ]

class EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL(Protocol):
    """EFI Simple Text Output Protocol"""
    guid = EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL_GUID

EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL._fields_ = [
    ('Reset', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL), BOOLEAN)),
    ('OutputString', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL), EFI_STRING)),
    ('TestString', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL), EFI_STRING)),
    ('QueryMode', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL), UINTN, POINTER(UINTN), POINTER(UINTN))),
    ('SetMode', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL), UINTN)),
    ('SetAttribute', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL), UINTN)),
    ('ClearScreen', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL))),
    ('SetCursorPosition', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL), UINTN, UINTN)),
    ('EnableCursor', FUNC(POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL), BOOLEAN)),
    ('Mode', POINTER(SIMPLE_TEXT_OUTPUT_MODE)),
]

class ConfigurationTable(bits.cdata.Struct):
    """Decode the EFI Configuration Table"""
    _fields_ = [
        ('VendorGuid', EFI_GUID),
        ('VendorTable', c_void_p),
    ]

    _formats = {
        'VendorGuid' : bits.cdata._format_guid,
    }

class EFI_MEMORY_DESCRIPTOR(bits.cdata.Struct):
    _fields_ = [
        ('Type', UINT32),
        ('PhysicalStart', EFI_PHYSICAL_ADDRESS),
        ('VirtualStart', EFI_VIRTUAL_ADDRESS),
        ('NumberOfPages', UINT64),
        ('Attribute', UINT64),
    ]

class EFI_OPEN_PROTOCOL_INFORMATION_ENTRY(bits.cdata.Struct):
    _fields_ = [
        ('AgentHandle', EFI_HANDLE),
        ('ControllerHandle', EFI_HANDLE),
        ('Attributes', UINT32),
        ('OpenCount', UINT32),
    ]

class TableHeader(bits.cdata.Struct):
    """Decode the EFI Table Header"""
    _fields_ = [
        ('Signature', UINT64),
        ('Revision', UINT32),
        ('HeaderSize', UINT32),
        ('CRC32', UINT32),
        ('Reserved', UINT32),
    ]

EFI_ALLOCATE_TYPE = UINTN
AllocateAnyPages, AllocateMaxAddress, AllocateAddress, MaxAllocateType = range(4)

EFI_EVENT_NOTIFY = FUNC(EFI_EVENT, c_void_p, ret=None)

class EFI_BOOT_SERVICES(bits.cdata.Struct):
    """Decode the EFI Boot Services"""
    _fields_ = [
        ('Hdr', TableHeader),
        ('RaiseTPL', FUNC(EFI_TPL, ret=EFI_TPL)),
        ('RestoreTPL', FUNC(EFI_TPL, ret=None)),
        ('AllocatePages', FUNC(EFI_ALLOCATE_TYPE, EFI_MEMORY_TYPE, UINTN, POINTER(EFI_PHYSICAL_ADDRESS))),
        ('FreePages',  FUNC(EFI_PHYSICAL_ADDRESS, UINTN)),
        ('GetMemoryMap', FUNC(POINTER(UINTN), POINTER(EFI_MEMORY_DESCRIPTOR), POINTER(UINTN), POINTER(UINTN), POINTER(UINT32))),
        ('AllocatePool', FUNC(EFI_MEMORY_TYPE, UINTN, POINTER(c_void_p))),
        ('FreePool', FUNC(c_void_p)),
        ('CreateEvent', FUNC(UINT32, EFI_TPL, EFI_EVENT_NOTIFY, c_void_p, POINTER(EFI_EVENT))),
        ('SetTimer', FUNC(EFI_EVENT, EFI_TIMER_DELAY, UINT64)),
        ('WaitForEvent', FUNC(UINTN, POINTER(EFI_EVENT), POINTER(UINTN))),
        ('SignalEvent', FUNC(EFI_EVENT)),
        ('CloseEvent', FUNC(EFI_EVENT)),
        ('CheckEvent', FUNC(EFI_EVENT)),
        ('InstallProtocolInterface',  FUNC(POINTER(EFI_HANDLE), POINTER(EFI_GUID), EFI_INTERFACE_TYPE, c_void_p)),
        ('ReinstallProtocolInterface', FUNC(EFI_HANDLE, POINTER(EFI_GUID), c_void_p, c_void_p)),
        ('UninstallProtocolInterface', FUNC(EFI_HANDLE, POINTER(EFI_GUID), c_void_p)),
        ('HandleProtocol', FUNC(EFI_HANDLE, POINTER(EFI_GUID), POINTER(c_void_p))),
        ('Reserved', c_void_p),
        ('RegisterProtocolNotify', FUNC(POINTER(EFI_GUID), EFI_EVENT, POINTER(c_void_p))),
        ('LocateHandle',  FUNC(EFI_LOCATE_SEARCH_TYPE, POINTER(EFI_GUID), c_void_p, POINTER(UINTN), POINTER(EFI_HANDLE))),
        ('LocateDevicePath',  FUNC(POINTER(EFI_GUID), POINTER(POINTER(EFI_DEVICE_PATH_PROTOCOL)), POINTER(EFI_HANDLE))),
        ('InstallConfigurationTable', FUNC(POINTER(EFI_GUID), c_void_p)),
        ('LoadImage', FUNC(BOOLEAN, EFI_HANDLE, POINTER(EFI_DEVICE_PATH_PROTOCOL), c_void_p, UINTN, POINTER(EFI_HANDLE))),
        ('StartImage', FUNC(EFI_HANDLE, POINTER(UINTN), POINTER(POINTER(CHAR16)))),
        ('Exit', FUNC(EFI_HANDLE, EFI_STATUS, UINTN, POINTER(CHAR16))),
        ('UnloadImage', FUNC(EFI_HANDLE)),
        ('ExitBootServices', FUNC(EFI_HANDLE, UINTN)),
        ('GetNextMonotonicCount', FUNC(POINTER(UINT64))),
        ('Stall', FUNC(UINTN)),
        ('SetWatchdogTimer', FUNC(UINTN, UINT64, UINTN, POINTER(CHAR16))),
        ('ConnectController',  FUNC(EFI_HANDLE, POINTER(EFI_HANDLE), POINTER(EFI_DEVICE_PATH_PROTOCOL), BOOLEAN)),
        ('DisconnectController', FUNC(EFI_HANDLE, EFI_HANDLE, EFI_HANDLE)),
        ('OpenProtocol', FUNC(EFI_HANDLE, POINTER(EFI_GUID), POINTER(c_void_p), EFI_HANDLE, EFI_HANDLE, UINT32)),
        ('CloseProtocol', FUNC(EFI_HANDLE, POINTER(EFI_GUID), EFI_HANDLE, EFI_HANDLE)),
        ('OpenProtocolInformation', FUNC(EFI_HANDLE, POINTER(EFI_GUID), POINTER(POINTER(EFI_OPEN_PROTOCOL_INFORMATION_ENTRY)), POINTER(UINTN))),
        ('ProtocolsPerHandle', FUNC(EFI_HANDLE, POINTER(POINTER(POINTER(EFI_GUID))), POINTER(UINTN))),
        ('LocateHandleBuffer', FUNC(EFI_LOCATE_SEARCH_TYPE, POINTER(EFI_GUID), c_void_p, POINTER(UINTN), POINTER(POINTER(EFI_HANDLE)))),
        ('LocateProtocol', FUNC(POINTER(EFI_GUID), c_void_p, POINTER(c_void_p))),
        ('InstallMultipleProtocolInterfaces', c_void_p),
        ('UninstallMultipleProtocolInterfaces', c_void_p),
        ('CalculateCrc32', FUNC(c_void_p, UINTN, POINTER(UINT32))),
        ('CopyMem', FUNC(c_void_p, c_void_p, UINTN)),
        ('SetMem', FUNC(c_void_p, UINTN, UINT8)),
        ('CreateEventEx', FUNC(UINT32, EFI_TPL, EFI_EVENT_NOTIFY, c_void_p, POINTER(EFI_GUID), POINTER(EFI_EVENT))),
    ]

class EFI_TIME(bits.cdata.Struct):
    _fields_ = [
        ('Year', UINT16),
        ('Month', UINT8),
        ('Day', UINT8),
        ('Hour', UINT8),
        ('Minute', UINT8),
        ('Second', UINT8),
        ('Pad1', UINT8),
        ('Nanosecond', UINT32),
        ('TimeZone', INT16),
        ('Daylight', UINT8),
        ('Pad2', UINT8),
    ]

class EFI_TIME_CAPABILITIES(bits.cdata.Struct):
    _fields_ = [
        ('Resolution', UINT32),
        ('Accuracy', UINT32),
        ('SetsToZero', BOOLEAN),
    ]

EFI_RESET_TYPE = UINTN
EfiResetCold, EfiResetWarm, EfiResetShutdown = range(3)

class EFI_CAPSULE_HEADER(bits.cdata.Struct):
    _fields_ = [
        ('CapsuleGuid', EFI_GUID),
        ('HeaderSize', UINT32),
        ('Flags', UINT32),
        ('CapsuleImageSize', UINT32),
    ]

class EFI_RUNTIME_SERVICES(bits.cdata.Struct):
    """Decode the EFI Runtime Services"""
    _fields_ = [
        ('Hdr', TableHeader),
        ('GetTime', FUNC(POINTER(EFI_TIME), POINTER(EFI_TIME_CAPABILITIES))),
        ('SetTime', FUNC(POINTER(EFI_TIME))),
        ('GetWakeupTime', FUNC(POINTER(BOOLEAN), POINTER(BOOLEAN), POINTER(EFI_TIME))),
        ('SetWakeupTime', FUNC(BOOLEAN, POINTER(EFI_TIME))),
        ('SetVirtualAddressMap', FUNC(UINTN, UINTN, UINT32, POINTER(EFI_MEMORY_DESCRIPTOR))),
        ('ConvertPointer', FUNC(UINTN, POINTER(c_void_p))),
        ('GetVariable', FUNC(EFI_STRING, POINTER(EFI_GUID), POINTER(UINT32), POINTER(UINTN), c_void_p)),
        ('GetNextVariableName', FUNC(POINTER(UINTN), POINTER(CHAR16), POINTER(EFI_GUID))),
        ('SetVariable', FUNC(EFI_STRING, POINTER(EFI_GUID), UINT32, UINTN, c_void_p)),
        ('GetNextHighMonotonicCount', FUNC(POINTER(UINT32))),
        ('ResetSystem', FUNC(EFI_RESET_TYPE, EFI_STATUS, UINTN, c_void_p)),
        ('UpdateCapsule', FUNC(POINTER(POINTER(EFI_CAPSULE_HEADER)), UINTN, EFI_PHYSICAL_ADDRESS)),
        ('QueryCapsuleCapabilities', FUNC(POINTER(POINTER(EFI_CAPSULE_HEADER)), UINTN, UINT64, EFI_RESET_TYPE)),
        ('QueryVariableInfo', FUNC(UINT32, POINTER(UINT64), POINTER(UINT64), POINTER(UINT64))),
    ]

class EFI_SYSTEM_TABLE(bits.cdata.Struct):
    """Decode the EFI System Table."""
    _fields_ = [
        ('Hdr', TableHeader),
        ('FirmwareVendor', EFI_STRING),
        ('FirmwareRevision', UINT32),
        ('ConsoleInHandle', EFI_HANDLE),
        ('ConIn', POINTER(EFI_SIMPLE_TEXT_INPUT_PROTOCOL)),
        ('ConsoleOutHandle', EFI_HANDLE),
        ('ConOut', POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL)),
        ('StandardErrorHandle', EFI_HANDLE),
        ('StdErr', POINTER(EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL)),
        ('RuntimeServices', POINTER(EFI_RUNTIME_SERVICES)),
        ('BootServices', POINTER(EFI_BOOT_SERVICES)),
        ('NumberOfTableEntries', UINTN),
        ('ConfigurationTablePtr', POINTER(ConfigurationTable)),
    ]

    @property
    def ConfigurationTable(self):
        ptr = cast(self.ConfigurationTablePtr, c_void_p)
        return (ConfigurationTable * self.NumberOfTableEntries).from_address(ptr.value)

    @property
    def ConfigurationTableDict(self):
        return OrderedDict((t.VendorGuid, t.VendorTable) for t in self.ConfigurationTable)

system_table = EFI_SYSTEM_TABLE.from_address(_efi._system_table)

TPL_APPLICATION = 4
TPL_CALLBACK = 8
TPL_NOTIFY = 16
TPL_HIGH_LEVEL = 31

EVT_TIMER = 0x80000000
EVT_RUNTIME = 0x40000000
EVT_NOTIFY_WAIT = 0x100
EVT_NOTIFY_SIGNAL = 0x200

class event_signal(object):
    """A wrapper around an EFI_EVENT of type EVT_NOTIFY_SIGNAL

    Used for cases that should busy-loop calling some function until complete.

    The caller must ensure that the event does not get signaled after the
    event_signal gets destroyed."""
    def __init__(self, abort=None):
        self.signaled = False
        self.closed = False
        self.event = create_event(self._set_signaled, abort=abort)

    def _set_signaled(self):
        self.signaled = True

    def close(self):
        if not self.closed:
            close_event(self.event)
        self.closed = True

    def __del__(self):
        self.close()

    def __enter__(self):
        if self.closed:
            raise ValueError("Cannot enter context with closed event")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

class EFI_LOADED_IMAGE_PROTOCOL(Protocol):
    """EFI Loaded Image Protocol"""
    guid = EFI_LOADED_IMAGE_PROTOCOL_GUID
    _fields_ = [
        ('Revision', UINT32),
        ('ParentHandle', EFI_HANDLE),
        ('SystemTable', POINTER(EFI_SYSTEM_TABLE)),
        ('DeviceHandle', EFI_HANDLE),
        ('FilePath', POINTER(EFI_DEVICE_PATH_PROTOCOL)),
        ('Reserved', c_void_p),
        ('LoadOptionsSize', UINT32),
        ('LoadOptions', c_void_p),
        ('ImageBase', c_void_p),
        ('ImageSize', UINT64),
        ('ImageCodeType', EFI_MEMORY_TYPE),
        ('ImageDataType', EFI_MEMORY_TYPE),
        ('Unload', FUNC(EFI_HANDLE)),
    ]

class EFI_FILE_PROTOCOL(bits.cdata.Struct):
    """EFI File Protocol"""
    pass

EFI_FILE_PROTOCOL._fields_ = [
    ('Revision', UINT64),
    ('Open', FUNC(POINTER(EFI_FILE_PROTOCOL), POINTER(POINTER(EFI_FILE_PROTOCOL)), EFI_STRING, UINT64, UINT64)),
    ('Close', FUNC(POINTER(EFI_FILE_PROTOCOL))),
    ('Delete', FUNC(POINTER(EFI_FILE_PROTOCOL))),
    ('Read', FUNC(POINTER(EFI_FILE_PROTOCOL), POINTER(UINTN), c_void_p)),
    ('Write', FUNC(POINTER(EFI_FILE_PROTOCOL), POINTER(UINTN), c_void_p)),
    ('GetPosition', FUNC(POINTER(EFI_FILE_PROTOCOL), POINTER(UINT64))),
    ('SetPosition', FUNC(POINTER(EFI_FILE_PROTOCOL), UINT64)),
    ('GetInfo', FUNC(POINTER(EFI_FILE_PROTOCOL), POINTER(EFI_GUID), POINTER(UINTN), c_void_p)),
    ('SetInfo', FUNC(POINTER(EFI_FILE_PROTOCOL), POINTER(EFI_GUID), UINTN, c_void_p)),
    ('Flush', FUNC(POINTER(EFI_FILE_PROTOCOL))),
]

class EFI_SIMPLE_FILE_SYSTEM_PROTOCOL(Protocol):
    """EFI Simple File System Protocol"""
    guid = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_GUID

    @property
    def root(self):
        root_ptr = POINTER(EFI_FILE_PROTOCOL)()
        check_status(self.OpenVolume(byref(self), byref(root_ptr)))
        return efi_file(root_ptr.contents)

EFI_SIMPLE_FILE_SYSTEM_PROTOCOL._fields_ = [
    ('Revision', UINT64),
    ('OpenVolume', FUNC(POINTER(EFI_SIMPLE_FILE_SYSTEM_PROTOCOL), POINTER(POINTER(EFI_FILE_PROTOCOL)))),
]

def make_UCS2_name_property():
    """Create a variable-sized UCS2-encoded name property at the end of the structure

    Automatically resizes the structure and updates the field named "Size"
    when set."""
    def _get_name(self):
        return wstring_at(addressof(self) + sizeof(self.__class__))

    def _set_name(self, name):
        b = create_unicode_buffer(name)
        resize(self, sizeof(self.__class__) + sizeof(b))
        memmove(addressof(self) + sizeof(self.__class__), addressof(b), sizeof(b))
        self.Size = sizeof(b)

    return property(_get_name, _set_name)

class EFI_FILE_INFO(bits.cdata.Struct):
    """EFI File Info"""
    _fields_ = [
        ('Size', UINT64),
        ('FileSize', UINT64),
        ('PhysicalSize', UINT64),
        ('CreateTime', EFI_TIME),
        ('LastAccessTime', EFI_TIME),
        ('ModificationTime', EFI_TIME),
        ('Attribute', UINT64),
    ]

    FileName = make_UCS2_name_property()

class EFI_FILE_SYSTEM_INFO(bits.cdata.Struct):
    """EFI File System Info"""
    _pack_ = 4
    _fields_ = [
        ('Size', UINT64),
        ('ReadOnly', BOOLEAN),
        ('_pad', UINT8 * 7),
        ('VolumeSize', UINT64),
        ('FreeSpace', UINT64),
        ('BlockSize', UINT32),
    ]

    VolumeLabel = make_UCS2_name_property()

class efi_file(object):
    """A file-like object for an EFI file"""
    def __init__(self, file_protocol):
        self.file_protocol = file_protocol
        self.closed = False

    def _check_closed(self):
        if self.closed:
            raise ValueError("I/O operation on closed file")

    def __del__(self):
        self.close()

    def close(self):
        if not self.closed:
            check_status(self.file_protocol.Close(byref(self.file_protocol)))
            self.closed = True

    def delete(self):
        self._check_closed()
        try:
            check_status(self.file_protocol.Delete(byref(self.file_protocol)))
        finally:
            self.closed = True

    # Context management protocol
    def __enter__(self):
        if self.closed:
            raise ValueError("Cannot enter context with closed file")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        self.close()

    def flush(self):
        self._check_closed()
        check_status(self.file_protocol.Flush(byref(self.file_protocol)))

    def read(self, size=-1):
        self._check_closed()
        if size < 0:
            try:
                size = self.file_info.FileSize - self.tell()
            except EFIException as e:
                size = self.file_info.FileSize
        size = UINTN(size)
        buf = create_string_buffer(0)
        resize(buf, size.value)
        check_status(self.file_protocol.Read(byref(self.file_protocol), byref(size), byref(buf)))
        if size.value != sizeof(buf):
            resize(buf, size.value)
        return buf.raw

    def seek(self, offset, whence=0):
        self._check_closed()
        if whence == 0:
            pos = offset
        elif whence == 1:
            pos = self.tell() + offset
        elif whence == 2:
            pos = self.file_info.FileSize + offset
        else:
            raise ValueError("seek: whence makes no sense: {}".format(whence))
        check_status(self.file_protocol.SetPosition(byref(self.file_protocol), pos))

    def tell(self):
        self._check_closed()
        pos = c_uint64()
        check_status(self.file_protocol.GetPosition(byref(self.file_protocol), byref(pos)))
        return pos.value

    def write(self, s):
        self._check_closed()
        buf = create_string_buffer(s, len(s))
        size = UINTN(sizeof(buf))
        check_status(self.file_protocol.Write(byref(self.file_protocol), byref(size), byref(buf)))

    def open(self, name, mode, attrib=0):
        self._check_closed()
        new_protocol = POINTER(EFI_FILE_PROTOCOL)()
        check_status(self.file_protocol.Open(byref(self.file_protocol), byref(new_protocol), name, mode, attrib))
        return efi_file(new_protocol.contents)

    def create(self, name, attrib=0):
        """Create a file. Shorthand for open with read/write/create."""
        return self.open(name, EFI_FILE_MODE_CREATE | EFI_FILE_MODE_READ | EFI_FILE_MODE_WRITE, attrib)

    def mkdir(self, name, attrib=0):
        """Make a directory. Shorthand for create EFI_FILE_DIRECTORY.

        attrib, if specified, provides additional attributes beyond EFI_FILE_DIRECTORY."""
        return self.create(name, EFI_FILE_DIRECTORY | attrib)

    def _get_info(self, information_type_guid, info):
        self._check_closed()
        guid = EFI_GUID(information_type_guid)
        size = UINTN()
        status = self.file_protocol.GetInfo(byref(self.file_protocol), byref(guid), byref(size), 0)
        if status != EFI_BUFFER_TOO_SMALL:
            check_status(status)
        resize(info, size.value)
        check_status(self.file_protocol.GetInfo(byref(self.file_protocol), byref(guid), byref(size), byref(info)))
        return info

    def get_file_info(self):
        return self._get_info(EFI_FILE_INFO_ID, EFI_FILE_INFO())

    def get_file_system_info(self):
        return self._get_info(EFI_FILE_SYSTEM_INFO_ID, EFI_FILE_SYSTEM_INFO())

    def get_volume_label(self):
        return self._get_info(EFI_FILE_SYSTEM_VOLUME_LABEL_ID, create_unicode_buffer(0)).value

    def _set_info(self, information_type_guid, info):
        self._check_closed()
        guid = EFI_GUID(information_type_guid)
        check_status(self.file_protocol.SetInfo(byref(self.file_protocol), byref(guid), byref(info), byref(info)))

    def set_file_info(self, info):
        self._set_info(EFI_FILE_INFO_ID, info)

    def set_file_system_info(self, info):
        self._set_info(EFI_FILE_SYSTEM_INFO_ID, info)

    def set_volume_label(self, label):
        buf = create_unicode_buffer(label)
        self._set_info(EFI_FILE_SYSTEM_VOLUME_LABEL_ID, buf)

    file_info = property(get_file_info, set_file_info)
    file_system_info = property(get_file_system_info, set_file_system_info)
    volume_label = property(get_volume_label, set_volume_label)

EFI_FILE_MODE_READ = 0x0000000000000001
EFI_FILE_MODE_WRITE = 0x0000000000000002
EFI_FILE_MODE_CREATE = 0x8000000000000000

EFI_FILE_READ_ONLY = 0x0000000000000001
EFI_FILE_HIDDEN = 0x0000000000000002
EFI_FILE_SYSTEM = 0x0000000000000004
EFI_FILE_RESERVED = 0x0000000000000008
EFI_FILE_DIRECTORY = 0x0000000000000010
EFI_FILE_ARCHIVE = 0x0000000000000020

def make_service_binding_protocol(name):
    """Create a protocol class for an EFI_SERVICE_BINDING_PROTOCOL

    name should be the name of the class without the leading EFI_ or trailing
    _SERVICE_BINDING_PROTOCOL.  The corresponding GUID and child protocol
    should already exist."""
    sbp_name = "EFI_{}_SERVICE_BINDING_PROTOCOL".format(name)
    guid = globals()[sbp_name + "_GUID"]
    cls = type(sbp_name, (Protocol,), dict(guid=guid))
    cls._fields_ = [
        ('CreateChild', FUNC(POINTER(cls), POINTER(EFI_HANDLE))),
        ('DestroyChild', FUNC(POINTER(cls), EFI_HANDLE)),
    ]
    child_protocol = globals()["EFI_{}_PROTOCOL".format(name)]
    def child(self):
        handle = EFI_HANDLE()
        check_status(self.CreateChild(self, byref(handle)))
        return child_protocol.from_handle(handle)

    cls.child = child
    globals()[sbp_name] = cls

class EFI_IPv4_ADDRESS(bits.cdata.Struct):
    _fields_ = [
        ('Addr', UINT8*4),
    ]

    def __str__(self):
        return "{}.{}.{}.{}".format(*self.Addr)

class EFI_IP4_CONFIG_DATA(bits.cdata.Struct):
    _fields_ = [
        ('DefaultProtocol', UINT8),
        ('AcceptAnyProtocol', BOOLEAN),
        ('AcceptIcmpErrors', BOOLEAN),
        ('AcceptBroadcast', BOOLEAN),
        ('AcceptPromiscuous', BOOLEAN),
        ('UseDefaultAddress', BOOLEAN),
        ('StationAddress', EFI_IPv4_ADDRESS),
        ('SubnetMask', EFI_IPv4_ADDRESS),
        ('TypeOfService', UINT8),
        ('TimeToLive', UINT8),
        ('DoNotFragment', BOOLEAN),
        ('RawData', BOOLEAN),
        ('ReceiveTimeout', UINT32),
        ('TransmitTimeout', UINT32),
    ]

class EFI_IP4_ROUTE_TABLE(bits.cdata.Struct):
    _fields_ = [
        ('SubnetAddress', EFI_IPv4_ADDRESS),
        ('SubnetMask', EFI_IPv4_ADDRESS),
        ('GatewayAddress', EFI_IPv4_ADDRESS),
    ]

class EFI_IP4_IPCONFIG_DATA(bits.cdata.Struct):
    _fields_ = [
        ('StationAddress', EFI_IPv4_ADDRESS),
        ('SubnetMask', EFI_IPv4_ADDRESS),
        ('RouteTableSize', UINT32),
        ('RouteTable', POINTER(EFI_IP4_ROUTE_TABLE)),
    ]

class EFI_IP4_ICMP_TYPE(bits.cdata.Struct):
    _fields_ = [
        ('Type', UINT8),
        ('Code', UINT8),
    ]

class EFI_IP4_MODE_DATA(bits.cdata.Struct):
    _fields_ = [
        ('IsStarted', BOOLEAN),
        ('MaxPacketSize', UINT32),
        ('ConfigData', EFI_IP4_CONFIG_DATA),
        ('IsConfigured', BOOLEAN),
        ('GroupCount', UINT32),
        ('GroupTable', POINTER(EFI_IPv4_ADDRESS)),
        ('RouteCount', UINT32),
        ('RouteTable', POINTER(EFI_IP4_ROUTE_TABLE)),
        ('IcmpTypeCount', UINT32),
        ('IcmpTypeList', POINTER(EFI_IP4_ICMP_TYPE)),
    ]

class EFI_IP4_CONFIG_PROTOCOL(Protocol):
    guid = EFI_IP4_CONFIG_PROTOCOL_GUID

EFI_IP4_CONFIG_PROTOCOL._fields_ = [
    ('Start', FUNC(POINTER(EFI_IP4_CONFIG_PROTOCOL), EFI_EVENT, EFI_EVENT)),
    ('Stop', FUNC(POINTER(EFI_IP4_CONFIG_PROTOCOL))),
    ('GetData', FUNC(POINTER(EFI_IP4_CONFIG_PROTOCOL), POINTER(UINTN), POINTER(EFI_IP4_IPCONFIG_DATA))),
]

class EFI_MAC_ADDRESS(bits.cdata.Struct):
    _fields_ = [
        ('Addr', UINT8*32),
    ]

EFI_IP4_CONFIG2_DATA_TYPE = UINT32
(
    Ip4Config2DataTypeInterfaceInfo,
    Ip4Config2DataTypePolicy,
    Ip4Config2DataTypeManualAddress,
    Ip4Config2DataTypeGateway,
    Ip4Config2DataTypeDnsServer,
    Ip4Config2DataTypeMaximum,
) = range(6)

class EFI_IP4_CONFIG2_INTERFACE_INFO(bits.cdata.Struct):
    _fields_ = [
        ('Name', CHAR16 * 32),
        ('IfType', UINT8),
        ('HwAddressSize', UINT32),
        ('HwAddress', EFI_MAC_ADDRESS),
        ('StationAddress', EFI_IPv4_ADDRESS),
        ('SubnetMask', EFI_IPv4_ADDRESS),
        ('RouteTableSize', UINT32),
        ('RouteTable', POINTER(EFI_IP4_ROUTE_TABLE)),
    ]

EFI_IP4_CONFIG2_POLICY = UINT32
(
    Ip4Config2PolicyStatic,
    Ip4Config2PolicyDhcp,
    Ip4Config2PolicyMax,
) = range(3)

class EFI_IP4_CONFIG2_MANUAL_ADDRESS(bits.cdata.Struct):
    _fields_ = [
        ('Address', EFI_IPv4_ADDRESS),
        ('SubnetMask', EFI_IPv4_ADDRESS),
    ]

class EFI_IP4_CONFIG2_PROTOCOL(Protocol):
    guid = EFI_IP4_CONFIG2_PROTOCOL_GUID

EFI_IP4_CONFIG2_PROTOCOL._fields_ = [
    ('SetData', FUNC(POINTER(EFI_IP4_CONFIG2_PROTOCOL), EFI_IP4_CONFIG2_DATA_TYPE, UINTN, c_void_p)),
    ('GetData', FUNC(POINTER(EFI_IP4_CONFIG2_PROTOCOL), EFI_IP4_CONFIG2_DATA_TYPE, POINTER(UINTN), c_void_p)),
    ('RegisterDataNotify', FUNC(POINTER(EFI_IP4_CONFIG2_PROTOCOL), EFI_IP4_CONFIG2_DATA_TYPE, EFI_EVENT)),
    ('UnregisterDataNotify', FUNC(POINTER(EFI_IP4_CONFIG2_PROTOCOL), EFI_IP4_CONFIG2_DATA_TYPE, EFI_EVENT)),
]

class EFI_DNS4_CACHE_ENTRY(bits.cdata.Struct):
    _fields_ = [
        ('HostName', c_wchar_p),
        ('IpAddress', POINTER(EFI_IPv4_ADDRESS)),
        ('Timeout', UINT32),
    ]

class EFI_DNS4_CONFIG_DATA(bits.cdata.Struct):
    _fields_ = [
        ('DnsServerListCount', UINTN),
        ('DnsServerList', POINTER(EFI_IPv4_ADDRESS)),
        ('UseDefaultSetting', BOOLEAN),
        ('EnableDnsCache', BOOLEAN),
        ('Protocol', UINT8),
        ('StationIp', EFI_IPv4_ADDRESS),
        ('SubnetMask', EFI_IPv4_ADDRESS),
        ('LocalPort', UINT16),
        ('RetryCount', UINT32),
        ('RetryInterval', UINT32),
    ]

class EFI_DNS4_MODE_DATA(bits.cdata.Struct):
    _fields_ = [
        ('DnsConfigData', EFI_DNS4_CONFIG_DATA),
        ('DnsServerCount', UINT32),
        ('DnsServerList', POINTER(EFI_IPv4_ADDRESS)),
        ('DnsCacheCount', UINT32),
        ('DnsCacheList', POINTER(EFI_DNS4_CACHE_ENTRY)),
    ]

class DNS_HOST_TO_ADDR_DATA(bits.cdata.Struct):
    _fields_ = [
        ('IpCount', UINT32),
        ('IpList', POINTER(EFI_IPv4_ADDRESS)),
    ]

class DNS_ADDR_TO_HOST_DATA(bits.cdata.Struct):
    _fields_ = [
        ('HostName', c_wchar_p),
    ]

class DNS_RESOURCE_RECORD(bits.cdata.Struct):
    _fields_ = [
        ('QName', c_char_p),
        ('QType', UINT16),
        ('QClass', UINT16),
        ('TTL', UINT32),
        ('DataLength', UINT16),
        ('RData', POINTER(CHAR8)),
    ]

class DNS_GENERAL_LOOKUP_DATA(bits.cdata.Struct):
    _fields_ = [
        ('RRCount', UINTN),
        ('RRList', POINTER(DNS_RESOURCE_RECORD)),
    ]

class EFI_DNS4_RSP_DATA(bits.cdata.Union):
    _fields_ = [
        ('H2AData', POINTER(DNS_HOST_TO_ADDR_DATA)),
        ('A2HData', POINTER(DNS_ADDR_TO_HOST_DATA)),
        ('GLookupData', POINTER(DNS_GENERAL_LOOKUP_DATA)),
    ]

class EFI_DNS4_COMPLETION_TOKEN(bits.cdata.Struct):
    _fields_ = [
        ('Event', EFI_EVENT),
        ('Status', EFI_STATUS),
        ('RetryCount', UINT32),
        ('RetryInterval', UINT32),
        ('RspData', EFI_DNS4_RSP_DATA),
    ]

class EFI_DNS4_PROTOCOL(Protocol):
    guid = EFI_DNS4_PROTOCOL_GUID

EFI_DNS4_PROTOCOL._fields_ = [
    ('GetModeData', FUNC(POINTER(EFI_DNS4_PROTOCOL), POINTER(EFI_DNS4_MODE_DATA))),
    ('Configure', FUNC(POINTER(EFI_DNS4_PROTOCOL), POINTER(EFI_DNS4_CONFIG_DATA))),
    ('HostNameToIp', FUNC(POINTER(EFI_DNS4_PROTOCOL), c_wchar_p, POINTER(EFI_DNS4_COMPLETION_TOKEN))),
    ('IpToHostName', FUNC(POINTER(EFI_DNS4_PROTOCOL), EFI_IPv4_ADDRESS, POINTER(EFI_DNS4_COMPLETION_TOKEN))),
    ('GeneralLookUp', FUNC(POINTER(EFI_DNS4_PROTOCOL), c_char_p, UINT16, UINT16, POINTER(EFI_DNS4_COMPLETION_TOKEN))),
    ('UpdateDnsCache', FUNC(POINTER(EFI_DNS4_PROTOCOL), BOOLEAN, BOOLEAN, EFI_DNS4_CACHE_ENTRY)),
    ('Poll', FUNC(POINTER(EFI_DNS4_PROTOCOL))),
    ('Cancel', FUNC(POINTER(EFI_DNS4_PROTOCOL), POINTER(EFI_DNS4_COMPLETION_TOKEN))),
]

make_service_binding_protocol("DNS4")

EFI_TCP4_CONNECTION_STATE = UINT32
tcp4_connection_states = {
    0: 'Tcp4StateClosed',
    1: 'Tcp4StateListen',
    2: 'Tcp4StateSynSent',
    3: 'Tcp4StateSynReceived',
    4: 'Tcp4StateEstablished',
    5: 'Tcp4StateFinWait1',
    6: 'Tcp4StateFinWait2',
    7: 'Tcp4StateClosing',
    8: 'Tcp4StateTimeWait',
    9: 'Tcp4StateCloseWait',
    10: 'Tcp4StateLastAck',
}
globals().update(map(reversed, tcp4_connection_states.iteritems()))

class EFI_TCP4_ACCESS_POINT(bits.cdata.Struct):
    _fields_ = [
        ('UseDefaultAddress', BOOLEAN),
        ('StationAddress', EFI_IPv4_ADDRESS),
        ('SubnetMask', EFI_IPv4_ADDRESS),
        ('StationPort', UINT16),
        ('RemoteAddress', EFI_IPv4_ADDRESS),
        ('RemotePort', UINT16),
        ('ActiveFlag', BOOLEAN),
    ]

class EFI_TCP4_OPTION(bits.cdata.Struct):
    _fields_ = [
        ('ReceiveBufferSize', UINT32),
        ('SendBufferSize', UINT32),
        ('MaxSynBackLog', UINT32),
        ('ConnectionTimeout', UINT32),
        ('DataRetries', UINT32),
        ('FinTimeout', UINT32),
        ('TimeWaitTimeout', UINT32),
        ('KeepAliveProbes', UINT32),
        ('KeepAliveTime', UINT32),
        ('KeepAliveInterval', UINT32),
        ('EnableNagle', BOOLEAN),
        ('EnableTimeStamp', BOOLEAN),
        ('EnableWindowScaling', BOOLEAN),
        ('EnableSelectiveAck', BOOLEAN),
        ('EnablePathMtuDiscovery', BOOLEAN),
    ]

class EFI_TCP4_CONFIG_DATA(bits.cdata.Struct):
    _fields_ = [
        ('TypeOfService', UINT8),
        ('TimeToLive', UINT8),
        ('AccessPoint', EFI_TCP4_ACCESS_POINT),
        ('ControlOption', POINTER(EFI_TCP4_OPTION)),
    ]

class EFI_MANAGED_NETWORK_CONFIG_DATA(bits.cdata.Struct):
    _fields_ = [
        ('ReceivedQueueTimeoutValue', UINT32),
        ('TransmitQueueTimeoutValue', UINT32),
        ('ProtocolTypeFilter', UINT16),
        ('EnableUnicastReceive', BOOLEAN),
        ('EnableMulticastReceive', BOOLEAN),
        ('EnableBroadcastReceive', BOOLEAN),
        ('EnablePromiscuousReceive', BOOLEAN),
        ('FlushQueuesOnReset', BOOLEAN),
        ('EnableReceiveTimestamps', BOOLEAN),
        ('DisableBackgroundPolling', BOOLEAN),
    ]

MAX_MCAST_FILTER_CNT = 16

class EFI_SIMPLE_NETWORK_MODE(bits.cdata.Struct):
    _fields_ = [
        ('State', UINT32),
        ('HwAddressSize', UINT32),
        ('MediaHeaderSize', UINT32),
        ('MaxPacketSize', UINT32),
        ('NvRamSize', UINT32),
        ('NvRamAccessSize', UINT32),
        ('ReceiveFilterMask', UINT32),
        ('ReceiveFilterSetting', UINT32),
        ('MaxMCastFilterCount', UINT32),
        ('MCastFilterCount', UINT32),
        ('MCastFilter', EFI_MAC_ADDRESS * MAX_MCAST_FILTER_CNT),
        ('CurrentAddress', EFI_MAC_ADDRESS),
        ('BroadcastAddress', EFI_MAC_ADDRESS),
        ('PermanentAddress', EFI_MAC_ADDRESS),
        ('IfType', UINT8),
        ('MacAddressChangeable', BOOLEAN),
        ('MultipleTxSupported', BOOLEAN),
        ('MediaPresentSupported', BOOLEAN),
        ('MediaPresent', BOOLEAN),
    ]

class EFI_TCP4_COMPLETION_TOKEN(bits.cdata.Struct):
    _fields_ = [
        ('Event', EFI_EVENT),
        ('Status', EFI_STATUS),
    ]

class EFI_TCP4_CONNECTION_TOKEN(bits.cdata.Struct):
    _fields_ = [
        ('CompletionToken', EFI_TCP4_COMPLETION_TOKEN),
    ]

class EFI_TCP4_LISTEN_TOKEN(bits.cdata.Struct):
    _fields_ = [
        ('CompletionToken', EFI_TCP4_COMPLETION_TOKEN),
        ('NewChildHandle', EFI_HANDLE),
    ]

class EFI_TCP4_FRAGMENT_DATA(bits.cdata.Struct):
    _fields_ = [
        ('FragmentLength', UINT32),
        ('FragmentBuffer', c_void_p),
    ]

# FIXME: Support variable-length array for FragmentTable
class EFI_TCP4_RECEIVE_DATA(bits.cdata.Struct):
    _fields_ = [
        ('UrgentFlag', BOOLEAN),
        ('DataLength', UINT32),
        ('FragmentCount', UINT32),
        ('FragmentTable', EFI_TCP4_FRAGMENT_DATA * 1),
    ]

# FIXME: Support variable-length array for FragmentTable
class EFI_TCP4_TRANSMIT_DATA(bits.cdata.Struct):
    _fields_ = [
        ('Push', BOOLEAN),
        ('Urgent', BOOLEAN),
        ('DataLength', UINT32),
        ('FragmentCount', UINT32),
        ('FragmentTable', EFI_TCP4_FRAGMENT_DATA * 1),
    ]

class EFI_TCP4_RECEIVE_TRANSMIT_DATA(bits.cdata.Union):
    _fields_ = [
        ('RxData', POINTER(EFI_TCP4_RECEIVE_DATA)),
        ('TxData', POINTER(EFI_TCP4_TRANSMIT_DATA)),
    ]

class EFI_TCP4_IO_TOKEN(bits.cdata.Struct):
    _fields_ = [
        ('CompletionToken', EFI_TCP4_COMPLETION_TOKEN),
        ('Packet', EFI_TCP4_RECEIVE_TRANSMIT_DATA),
    ]

class EFI_TCP4_CLOSE_TOKEN(bits.cdata.Struct):
    _fields_ = [
        ('CompletionToken', EFI_TCP4_COMPLETION_TOKEN),
        ('AbortOnClose', BOOLEAN),
    ]

class EFI_TCP4_PROTOCOL(Protocol):
    guid = EFI_TCP4_PROTOCOL_GUID

EFI_TCP4_PROTOCOL._fields_ = [
    ('GetModeData', FUNC(POINTER(EFI_TCP4_PROTOCOL), POINTER(EFI_TCP4_CONNECTION_STATE), POINTER(EFI_TCP4_CONFIG_DATA), POINTER(EFI_IP4_MODE_DATA), POINTER(EFI_MANAGED_NETWORK_CONFIG_DATA), POINTER(EFI_SIMPLE_NETWORK_MODE))),
    ('Configure', FUNC(POINTER(EFI_TCP4_PROTOCOL), POINTER(EFI_TCP4_CONFIG_DATA))),
    ('Routes', FUNC(POINTER(EFI_TCP4_PROTOCOL), BOOLEAN, POINTER(EFI_IPv4_ADDRESS), POINTER(EFI_IPv4_ADDRESS), POINTER(EFI_IPv4_ADDRESS))),
    ('Connect', FUNC(POINTER(EFI_TCP4_PROTOCOL), POINTER(EFI_TCP4_CONNECTION_TOKEN))),
    ('Accept', FUNC(POINTER(EFI_TCP4_PROTOCOL), POINTER(EFI_TCP4_LISTEN_TOKEN))),
    ('Transmit', FUNC(POINTER(EFI_TCP4_PROTOCOL), POINTER(EFI_TCP4_IO_TOKEN))),
    ('Receive', FUNC(POINTER(EFI_TCP4_PROTOCOL), POINTER(EFI_TCP4_IO_TOKEN))),
    ('Close', FUNC(POINTER(EFI_TCP4_PROTOCOL), POINTER(EFI_TCP4_CLOSE_TOKEN))),
    ('Cancel', FUNC(POINTER(EFI_TCP4_PROTOCOL), POINTER(EFI_TCP4_COMPLETION_TOKEN))),
    ('Poll', FUNC(POINTER(EFI_TCP4_PROTOCOL))),
]

make_service_binding_protocol("TCP4")

EFI_OPEN_PROTOCOL_BY_HANDLE_PROTOCOL = 0x00000001
EFI_OPEN_PROTOCOL_GET_PROTOCOL = 0x00000002
EFI_OPEN_PROTOCOL_TEST_PROTOCOL = 0x00000004
EFI_OPEN_PROTOCOL_BY_CHILD_CONTROLLER = 0x00000008
EFI_OPEN_PROTOCOL_BY_DRIVER = 0x00000010
EFI_OPEN_PROTOCOL_EXCLUSIVE = 0x00000020

def locate_handles(protocol_guid=None):
    """Locate handles supporting a given protocol, or all handles if protocol_guid is None"""
    if protocol_guid is not None:
        guid = EFI_GUID(protocol_guid)
        guid_ref = byref(guid)
        search_type = ByProtocol
    else:
        guid_ref = None
        search_type = AllHandles
    size = UINTN(0)
    status = system_table.BootServices.contents.LocateHandle(search_type, guid_ref, None, byref(size), None)
    if status != EFI_BUFFER_TOO_SMALL:
        check_status(status)
    handles = (EFI_HANDLE * (size.value / sizeof(EFI_HANDLE)))()
    check_status(system_table.BootServices.contents.LocateHandle(search_type, guid_ref, None, byref(size), handles))
    return handles

def get_protocol(handle, protocol_guid):
    """Get the given protocol of the given handle

    Uses OpenProtocol with the BITS image handle, so CloseProtocol is
    optional."""
    guid = EFI_GUID(protocol_guid)
    protocol_addr = c_void_p()
    check_status(system_table.BootServices.contents.OpenProtocol(handle, byref(guid), byref(protocol_addr), _efi._image_handle, None, EFI_OPEN_PROTOCOL_GET_PROTOCOL))
    return protocol_addr.value

# EFI errors have the high bit set, so use the pointer size to find out how
# high your EFI is.
EFI_ERROR = 1 << (8*ptrsize - 1)

efi_status_decode = {
    0: 'EFI_SUCCESS',
    1: 'EFI_WARN_UNKNOWN_GLYPH',
    2: 'EFI_WARN_DELETE_FAILURE',
    3: 'EFI_WARN_WRITE_FAILURE',
    4: 'EFI_WARN_BUFFER_TOO_SMALL',
    5: 'EFI_WARN_STALE_DATA',
    EFI_ERROR |  1: 'EFI_LOAD_ERROR',
    EFI_ERROR |  2: 'EFI_INVALID_PARAMETER',
    EFI_ERROR |  3: 'EFI_UNSUPPORTED',
    EFI_ERROR |  4: 'EFI_BAD_BUFFER_SIZE',
    EFI_ERROR |  5: 'EFI_BUFFER_TOO_SMALL',
    EFI_ERROR |  6: 'EFI_NOT_READY',
    EFI_ERROR |  7: 'EFI_DEVICE_ERROR',
    EFI_ERROR |  8: 'EFI_WRITE_PROTECTED',
    EFI_ERROR |  9: 'EFI_OUT_OF_RESOURCES',
    EFI_ERROR | 10: 'EFI_VOLUME_CORRUPTED',
    EFI_ERROR | 11: 'EFI_VOLUME_FULL',
    EFI_ERROR | 12: 'EFI_NO_MEDIA',
    EFI_ERROR | 13: 'EFI_MEDIA_CHANGED',
    EFI_ERROR | 14: 'EFI_NOT_FOUND',
    EFI_ERROR | 15: 'EFI_ACCESS_DENIED',
    EFI_ERROR | 16: 'EFI_NO_RESPONSE',
    EFI_ERROR | 17: 'EFI_NO_MAPPING',
    EFI_ERROR | 18: 'EFI_TIMEOUT',
    EFI_ERROR | 19: 'EFI_NOT_STARTED',
    EFI_ERROR | 20: 'EFI_ALREADY_STARTED',
    EFI_ERROR | 21: 'EFI_ABORTED',
    EFI_ERROR | 22: 'EFI_ICMP_ERROR',
    EFI_ERROR | 23: 'EFI_TFTP_ERROR',
    EFI_ERROR | 24: 'EFI_PROTOCOL_ERROR',
    EFI_ERROR | 25: 'EFI_INCOMPATIBLE_VERSION',
    EFI_ERROR | 26: 'EFI_SECURITY_VIOLATION',
    EFI_ERROR | 27: 'EFI_CRC_ERROR',
    EFI_ERROR | 28: 'EFI_END_OF_MEDIA',
    EFI_ERROR | 31: 'EFI_END_OF_FILE',
    EFI_ERROR | 32: 'EFI_INVALID_LANGUAGE',
    EFI_ERROR | 33: 'EFI_COMPROMISED_DATA',
    EFI_ERROR | 34: 'EFI_IP_ADDRESS_CONFLICT',
    EFI_ERROR | 100: 'EFI_NETWORK_UNREACHABLE',
    EFI_ERROR | 101: 'EFI_HOST_UNREACHABLE',
    EFI_ERROR | 102: 'EFI_PROTOCOL_UNREACHABLE',
    EFI_ERROR | 103: 'EFI_PORT_UNREACHABLE',
    EFI_ERROR | 104: 'EFI_CONNECTION_FIN',
    EFI_ERROR | 105: 'EFI_CONNECTION_RESET',
    EFI_ERROR | 106: 'EFI_CONNECTION_REFUSED',
}

# Create each of the values above as a constant referring to the corresponding EFI status code.
globals().update(map(reversed, efi_status_decode.iteritems()))

class EFIException(Exception):
    def __str__(self):
        return "[Error {:#x}] {}".format(self.args[0], efi_status_decode.get(self.args[0], "Unknown EFI error"))

def check_status(status):
    """Check an EFI status value, and raise an exception if not EFI_SUCCESS

    To check non-status values that may have the error bit set, use check_error_value instead."""
    if status != EFI_SUCCESS:
        raise EFIException(status)

def check_error_value(value):
    """Check a value that may have the error bit set

    Raises an exception if the error bit is set; otherwise, returns the value."""
    if value & EFI_ERROR:
        raise EFIException(value)
    return value

def loaded_image():
    return EFI_LOADED_IMAGE_PROTOCOL.from_handle(_efi._image_handle)

def get_boot_fs():
    return EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.from_handle(loaded_image().DeviceHandle).root

def print_variables():
    name = create_unicode_buffer("")
    size = UINTN(sizeof(name))
    guid = EFI_GUID()
    while True:
        status = system_table.RuntimeServices.contents.GetNextVariableName(byref(size), name, byref(guid))
        if status == EFI_NOT_FOUND:
            break
        if status == EFI_BUFFER_TOO_SMALL:
            resize(name, size.value)
            continue
        check_status(status)
        print(name.value, guid)
        data, attributes, data_size = get_variable(name, guid)
        print("attributes={:#x} size={} data:".format(attributes, data_size))
        print(bits.dumpmem(data.raw))

def get_variable(name, guid):
    attribute = UINT32(0)
    data = create_string_buffer(1)
    size = UINTN(sizeof(data))
    while True:
        status = system_table.RuntimeServices.contents.GetVariable(name, byref(guid), byref(attribute), byref(size), data)
        if status == EFI_NOT_FOUND:
            break
        if status == EFI_BUFFER_TOO_SMALL:
            resize(data, size.value)
            continue
        check_status(status)
        return data, attribute.value, size.value

def print_configurationtables():
    for tbl in system_table.ConfigurationTable:
        print(tbl)

def log_efi_info():
    with redirect.logonly():
        try:
            print()
            print("EFI system information:")
            print("Firmware Vendor:", system_table.FirmwareVendor)
            print("Firmware Revision: {:#x}".format(system_table.FirmwareRevision))
            print("Supported EFI configuration table UUIDs:")
            for t in system_table.ConfigurationTable:
                print(t.VendorGuid, known_uuids.get(t.VendorGuid.uuid, ''))
            print()
        except:
            print("Error printing EFI information:")
            import traceback
            traceback.print_exc()


EFI_LOCATE_SEARCH_TYPE = UINTN
AllHandles, ByRegisterNotify, ByProtocol = range(3)

EFI_HII_PACKAGE_TYPE_ALL          = 0x00
EFI_HII_PACKAGE_TYPE_GUID         = 0x01
EFI_HII_PACKAGE_FORMS             = 0x02
EFI_HII_PACKAGE_STRINGS           = 0x04
EFI_HII_PACKAGE_FONTS             = 0x05
EFI_HII_PACKAGE_IMAGES            = 0x06
EFI_HII_PACKAGE_SIMPLE_FONTS      = 0x07
EFI_HII_PACKAGE_DEVICE_PATH       = 0x08
EFI_HII_PACKAGE_KEYBOARD_LAYOUT   = 0x09
EFI_HII_PACKAGE_ANIMATIONS        = 0x0A
EFI_HII_PACKAGE_END               = 0xDF
EFI_HII_PACKAGE_TYPE_SYSTEM_BEGIN = 0xE0
EFI_HII_PACKAGE_TYPE_SYSTEM_END   = 0xFF

EFI_PCI_IO_PROTOCOL_WIDTH = UINTN
EfiPciIoWidthUint8, EfiPciIoWidthUint16, EfiPciIoWidthUint32, EfiPciIoWidthUint64, EfiPciIoWidthFifoUint8, EfiPciIoWidthFifoUint16, EfiPciIoWidthFifoUint32, EfiPciIoWidthFifoUint64, EfiPciIoWidthFillUint8, EfiPciIoWidthFillUint16, EfiPciIoWidthFillUint32, EfiPciIoWidthFillUint64, EfiPciIoWidthMaximum = range(13)

EFI_PCI_IO_PROTOCOL_ATTRIBUTE_OPERATION = UINTN
EfiPciIoAttributeOperationGet, EfiPciIoAttributeOperationSet, EfiPciIoAttributeOperationEnable, EfiPciIoAttributeOperationDisable, EfiPciIoAttributeOperationSupported, EfiPciIoAttributeOperationMaximum = range(6)

EFI_PCI_IO_PROTOCOL_OPERATION = UINTN
EfiPciIoOperationBusMasterRead, EfiPciIoOperationBusMasterWrite, EfiPciIoOperationBusMasterCommonBuffer, EfiPciIoOperationMaximum = range(4)

class EFI_PCI_IO_PROTOCOL(Protocol):
    """EFI PCI IO Protocol"""
    guid = EFI_PCI_IO_PROTOCOL_GUID

EFI_PCI_IO_PROTOCOL_IO_MEM = FUNC(POINTER(EFI_PCI_IO_PROTOCOL), EFI_PCI_IO_PROTOCOL_WIDTH, UINT8, UINT64, UINTN, c_void_p)

class EFI_PCI_IO_PROTOCOL_ACCESS(bits.cdata.Struct):
    """EFI PCI IO Protocol Access"""
    _fields_ = [
        ('Read', EFI_PCI_IO_PROTOCOL_IO_MEM),
        ('Write', EFI_PCI_IO_PROTOCOL_IO_MEM),
    ]

EFI_PCI_IO_PROTOCOL_CONFIG = FUNC(POINTER(EFI_PCI_IO_PROTOCOL), EFI_PCI_IO_PROTOCOL_WIDTH, UINT32, UINTN, c_void_p)

class EFI_PCI_IO_PROTOCOL_CONFIG_ACCESS(bits.cdata.Struct):
    """EFI PCI IO Protocol Config Access Protocol"""
    _fields_ = [
        ('Read', EFI_PCI_IO_PROTOCOL_CONFIG),
        ('Write', EFI_PCI_IO_PROTOCOL_CONFIG),
    ]

EFI_PCI_IO_PROTOCOL_POLL_IO_MEM = FUNC(POINTER(EFI_PCI_IO_PROTOCOL), EFI_PCI_IO_PROTOCOL_WIDTH, UINT8, UINT64, UINT64, UINT64, UINT64, POINTER(UINT64))

EFI_PCI_IO_PROTOCOL._fields_ = [
    ('PollMem', EFI_PCI_IO_PROTOCOL_POLL_IO_MEM),
    ('PollIo', EFI_PCI_IO_PROTOCOL_POLL_IO_MEM),
    ('Mem', EFI_PCI_IO_PROTOCOL_ACCESS),
    ('Io', EFI_PCI_IO_PROTOCOL_ACCESS),
    ('Pci', EFI_PCI_IO_PROTOCOL_CONFIG_ACCESS),
    ('CopyMem', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), EFI_PCI_IO_PROTOCOL_WIDTH, UINT8, UINT64, UINT8, UINT64, UINTN)),
    ('Map', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), EFI_PCI_IO_PROTOCOL_OPERATION, c_void_p, POINTER(UINTN), POINTER(EFI_PHYSICAL_ADDRESS), POINTER(c_void_p))),
    ('Unmap', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), c_void_p)),
    ('AllocateBuffer', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), EFI_ALLOCATE_TYPE, EFI_MEMORY_TYPE, UINTN, POINTER(c_void_p), UINT64)),
    ('FreeBuffer', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), UINTN, c_void_p)),
    ('Flush', FUNC(POINTER(EFI_PCI_IO_PROTOCOL))),
    ('GetLocation', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), POINTER(UINTN), POINTER(UINTN), POINTER(UINTN), POINTER(UINTN))),
    ('Attributes', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), EFI_PCI_IO_PROTOCOL_ATTRIBUTE_OPERATION, UINT64, POINTER(UINT64))),
    ('GetBarAttributes', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), UINT8, POINTER(UINT64), POINTER(c_void_p))),
    ('SetBarAttributes', FUNC(POINTER(EFI_PCI_IO_PROTOCOL), UINT64, UINT8, POINTER(UINT64), POINTER(UINT64))),
    ('RomSize', UINT64),
    ('RomImage', c_void_p),
]

_event_handlers = {}
_event_exiting = False

def _event_callback(event_value):
    global _event_handlers
    _event_handlers[event_value][0]()

_efi._set_event_callback(_event_callback)

def create_event(handler, timer=False, tpl=TPL_CALLBACK, abort=None):
    """Create an EFI_EVENT with the specified Python handler

    The event always has type EVT_NOTIFY_SIGNAL. Pass timer=True to
    additionally use EVT_TIMER.

    tpl specifies the TPL for the callback: either TPL_CALLBACK (default) or
    TPL_NOTIFY.

    abort provides a callback to be called if cleaning up all events before
    exiting Python.  Supply an abort callback if you need to tell some EFI
    object not to touch this event or associated data.

    Returns the EFI_EVENT.  Do not close directly; always call
    efi.close_event."""
    global _event_handlers, _event_exiting
    if _event_exiting:
        raise RuntimeError("Attempt to create_event while cleaning up events")
    type = EVT_NOTIFY_SIGNAL
    if timer:
        type |= EVT_TIMER
    event = EFI_EVENT()
    notify = cast(c_void_p(_efi._c_event_callback), EFI_EVENT_NOTIFY)
    # Safe to create before adding to handlers; nothing can signal it yet
    check_status(system_table.BootServices.contents.CreateEvent(type, tpl, notify, None, byref(event)))
    _event_handlers[event.value] = handler, abort
    return event

def close_event(event):
    """Close an EFI_EVENT created by efi.create_event"""
    global _event_handlers
    _event_handlers[event.value] # raise KeyError if not found
    check_status(system_table.BootServices.contents.CloseEvent(event))
    del _event_handlers[event.value]

@atexit.register
def close_all_events():
    global _event_handlers, _event_exiting
    _event_exiting = True
    for event_value, (handler, abort) in _event_handlers.iteritems():
        if abort is not None:
            try:
                abort()
            except Exception as e:
                print("Exception occurred during event abort function:")
                print(traceback.format_exc())
        try:
            close_event(EFI_EVENT(event_value))
        except Exception as e:
            pass

class event_set(object):
    def __init__(self):
        self.s = set()

    def create_event(self, *args, **kwargs):
        e = create_event(*args, **kwargs)
        self.s.add(e.value)
        return e

    def close_event(self, e):
        self.s.remove(e.value)
        close_event(e)

    def close_all(self):
        for ev in self.s:
            self.close_event(EFI_EVENT(ev))

_key_handlers = {}

# The C code packs the important bits of EFI_KEY_DATA into one pointer-sized
# value to avoid memory allocation.
def _unpack_key_data(d):
    key_data = EFI_KEY_DATA()
    if d & (1 << 16):
        key_data.Key.ScanCode = d & 0xffff
    else:
        key_data.Key.UnicodeChar = chr(d & 0xffff)
    key_data.KeyState.KeyShiftState = EFI_SHIFT_STATE_VALID | ((d >> 17) & 0x3ff)
    if d & (1 << 28):
        key_data.KeyState.KeyToggleState |= EFI_SCROLL_LOCK_ACTIVE
    if d & (1 << 29):
        key_data.KeyState.KeyToggleState |= EFI_NUM_LOCK_ACTIVE
    if d & (1 << 30):
        key_data.KeyState.KeyToggleState |= EFI_CAPS_LOCK_ACTIVE
    if d & (1 << 31):
        key_data.KeyState.KeyToggleState |= EFI_KEY_STATE_EXPOSED
    key_data.KeyState.KeyToggleState |= EFI_TOGGLE_STATE_VALID
    return key_data

def _key_callback(key_data_packed):
    global _key_handlers
    key_data = _unpack_key_data(key_data_packed)
    shift = 0
    if key_data.KeyState.KeyShiftState & EFI_SHIFT_STATE_VALID:
        shift = key_data.KeyState.KeyShiftState & ~EFI_SHIFT_STATE_VALID
    _key_handlers[key_data.Key.ScanCode, key_data.Key.UnicodeChar, shift][1]()

_efi._set_key_callback(_key_callback, sizeof(EFI_KEY_DATA))

def register_key_handler(handler, code=0, char='\0', shift=0):
    global _key_handlers
    if (code == 0 and char == '\0') or (code != 0 and char != '\0'):
        raise ValueError("Must provide exactly one of code and char")
    shift &= ~EFI_SHIFT_STATE_VALID
    dict_key = code, char, shift
    if dict_key in _key_handlers:
        raise RuntimeError("Duplicate key handler for key", dict_key)
    stiex = EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL.from_handle(system_table.ConsoleInHandle)
    handle = c_void_p()
    notify = cast(c_void_p(_efi._c_key_callback), EFI_KEY_NOTIFY_FUNCTION)
    key_data = EFI_KEY_DATA()
    key_data.Key.ScanCode = code
    key_data.Key.UnicodeChar = char
    if shift:
        key_data.KeyState.KeyShiftState = EFI_SHIFT_STATE_VALID | shift
    check_status(stiex.RegisterKeyNotify(stiex, byref(key_data), notify, byref(handle)))
    _key_handlers[dict_key] = (handle, handler)

def unregister_key_handler(code=0, char='\0', shift=0):
    global _key_handlers
    shift &= ~EFI_SHIFT_STATE_VALID
    handle, handler = _key_handlers[(code, char, shift)]
    stiex = EFI_SIMPLE_TEXT_INPUT_EX_PROTOCOL.from_handle(system_table.ConsoleInHandle)
    check_status(stiex.UnregisterKeyNotify(stiex, handle))
    del _key_handlers[(code, char, shift)]

@atexit.register
def unregister_all_key_handlers():
    global _key_handlers
    for k in _key_handlers.keys():
        unregister_key_handler(*k)

def raise_KeyboardInterrupt():
    raise KeyboardInterrupt()

def register_keyboard_interrupt_handler():
    for char in ('c', '\x03'):
        for shift in (EFI_LEFT_CONTROL_PRESSED, EFI_RIGHT_CONTROL_PRESSED):
            register_key_handler(raise_KeyboardInterrupt, char=char, shift=shift)

def list_pci_devices():
    SegmentNumber = UINTN()
    BusNumber = UINTN()
    DeviceNumber = UINTN()
    FunctionNumber = UINTN()
    handles = locate_handles(EFI_PCI_IO_PROTOCOL_GUID)
    for handle in handles:
        pci_io = EFI_PCI_IO_PROTOCOL.from_handle(handle)
        check_status(pci_io.GetLocation(byref(pci_io), byref(SegmentNumber), byref(BusNumber), byref(DeviceNumber), byref(FunctionNumber)))
        print("{}:{}:{}:{}".format(SegmentNumber.value, BusNumber.value, DeviceNumber.value, FunctionNumber.value))

def exit(status=0):
    if hasattr(_sys, "exitfunc"):
        _sys.exitfunc()
    system_table.BootServices.contents.Exit(_efi._image_handle, status, 0, None)
