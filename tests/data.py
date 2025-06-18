import datetime as dt
from dataclasses import dataclass
from typing import Annotated

from type2sql import Meta


# fmt: off
@dataclass
class SimpleRec:
    name:         Annotated[str,          Meta(name="ACCT_NM")]
    street:       Annotated[str,          Meta(name="ADDR_LN_TXT",  size=50)]
    street2:      Annotated[str | None,   Meta(name="ADDR_LN2_TXT", size=50)]
    balance:      Annotated[float | None, Meta(name="ACCT_BAL_AMT", size=(14,2))]
    last_updated: Annotated[dt.datetime,  Meta(name="LAST_UPD_TS", default="CURRENT_TIMESTAMP")]


@dataclass
class ArrayRec(SimpleRec):
    phones:       Annotated[list[str],    Meta(name="PH{n}_NUM", occurs=3)]


@dataclass
class NestedRec:
    name:         Annotated[str,          Meta(name="CUST_NM")]
    primary:      Annotated[ArrayRec,     Meta(name="PRI_{sub}")]
    secondary:    Annotated[ArrayRec,     Meta(name="SEC_{sub}")]


@dataclass
class SkipRec(NestedRec):
    linked:       Annotated[ArrayRec | None, Meta(skip=True)]
    has_links:    Annotated[bool,         Meta(name="LINKS_IND")]


@dataclass
class Address:
     street1: Annotated[str,              Meta(name="ST1_NM",  size=60)]
     street2: Annotated[str | None,       Meta(name="ST2_NM",  size=60)]
     city:    Annotated[str,              Meta(name="CITY_NM", size=30)]
     zip:     Annotated[str,              Meta(name="ZIP_CD",  size=9)]


@dataclass
class Customer:
     name: Annotated[str,                 Meta(name="CUST_NM", size=60)]
     addr: Annotated[list[Address],       Meta(name="ADDR{n}_{sub}", occurs=2)]


@dataclass
class NoAnno:
	a: Annotated[str, Meta(name="X")]
	b: str | None
	c: Annotated[list[int], Meta(name="C_{n}", occurs=2)]
	d: str
# fmt: on
