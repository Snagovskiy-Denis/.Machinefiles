from dataclasses import dataclass


@dataclass(frozen=True, slots=True)
class BluetoothAdvertisment:
    """
    Specification:

    https://docs.silabs.com/bluetooth/4.0/general/adv-and-scanning/bluetooth-adv-data-basics
    """
    len: int  # type + data length
    type: str  # for types decription see doc/types.pdf and doc/type.md
    payload: bytearray

    @classmethod
    def parse_packet(cls, hexidecimal_raw_data: str) -> list:
        package = bytearray.fromhex(
            hexidecimal_raw_data[2:] 
            if hexidecimal_raw_data.startswith("0x") 
            else hexidecimal_raw_data
        )

        packets = []

        while package:
            length, type_ = package.pop(0), hex(package.pop(1))
            value_length = length - 1
            body = package[:value_length]
            del package[:value_length]
            packets.append(cls(length, type_, body))

        return packets
