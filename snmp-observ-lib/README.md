# SNMP observability library

This lib can be used to generate dashboards, rows, panels for SNMP devices.

The library supports multiple metrics sources (`metricsSource`).

### Supported sources

|metricsSource|Description|MIBs|Known devices|Links|snmp_exporter modules|
|-|-|-|-|-|-|
|generic           |Generic SNMP device|IF-MIB,SNMPv2-MIB    |default choice||system,if_mib|
|cisco             | Cisco IoS devices |IF-MIB,SNMPv2-MIB, Cisco private mibs|-||system,if_mib|
|arista_sw            | Arista devices    |IF-MIB,SNMPv2-MIB,HOST-RESOURCES-MIB|-||system,if_mib,arista_sw,hrDevice,hrStorage|
|brocade_fcs       | Brocade           |IF-MIB,SNMPv2-MIB,SW-MIB|Brocade 6520 v7.4.1c, Brocade 300 v7.0.0c,Brocade BL 5480 v6.3.1c|system,if_mib|
|brocade_foundry | Brocade Foundry | FOUNDRY-SN-AGENT-MIB | Brocade MLXe (System Mode: MLX), IronWare Version V5.4.0eT163, Foundry FLS648 Foundry Networks, Inc. FLS648, IronWare Version 04.1.00bT7e1, Foundry FWSX424 Foundry Networks, Inc. FWSX424, IronWare Version 02.0.00aT1e0||system,if_mib|
|dell_force | Dell Force S-Series | IF-MIB,SNMPv2-MIB,F10-S-SERIES-CHASSIS-MIB | Dell Force S-Series ||system,if_mib|
|dlink_des | D-Link DES series | IF-MIB,SNMPv2-MIB,DLINK-AGENT-MIB | DGS-3420-26SC Gigabit Ethernet ||system,if_mib,dlink|
|eltex | Eltex  | IF-MIB, SNMPv2-MIB | - ||system,if_mib|
|eltex_mes | Eltex MES | IF-MIB, SNMPv2-MIB,ELTEX-MES-ISS-CPU-UTIL-MIB,ARICENT-ISS-MIB | MES 2448P ||system,if_mib,eltex_mes|
|extreme | Extreme EXOS | IF-MIB, SNMPv2-MIB,EXTREME-SYSTEM-MIB, EXTREME-SOFTWARE-MONITOR-MIB | - ||system,if_mib|
|f5_bigip | F5 BigIP | IF-MIB,SNMPv2-MIB,F5-BIGIP-SYSTEM-MIB | - |https://my.f5.com/manage/s/article/K13322|system,if_mib|
|fortigate | Fortinet Fortigate | IF-MIB,SNMPv2-MIB,FORTINET-FORTIGATE-MIB, ENTITY-MIB | v7.2.5 ||system,if_mib|
|hpe | HP Enterprise Switches | IF-MIB,SNMPv2-MIB,STATISTICS-MIB,NETSWITCH-MIB | HP ProCurve J4900B, HP J9728A 2920-48G | https://support.hpe.com/hpesc/public/docDisplay?sp4ts.oid=51079&docId=emr_na-c02597344|system,if_mib|
|huawei | Huawei VRP | IF-MIB,SNMPv2-MIB,HUAWEI-ENTITY-EXTENT-MIB | - | |system,if_mib|
|juniper | Juniper MX | IF-MIB,SNMPv2-MIB,JUNIPER-MIB | Juniper MX204 Edge Router, JUNOS 24.2R1-S1.10 | |system,if_mib|
|mikrotik | Mikrotik OS | HOST-RESOURCES-MIB,SNMPv2-MIB,MIKROTIK-MIB,IF-MIB | Router OS 7.3 | |system,if_mib|
|netgear | Netgear FastPath switches | HOST-RESOURCES-MIB,SNMPv2-MIB,FASTPATH-SWITCHING-MIB,FASTPATH-BOXSERVICES-PRIVATE-MIB,IF-MIB | Netgear M5300-28G | https://kb.netgear.com/24352/MIBs-for-Smart-switches |system,if_mib|
|qtech | QTech | QTECH-MIB,EtherLike-MIB,HOST-RESOURCES-MIB,SNMPv2-MIB,ENTITY-MIB,IF-MIB | | |system,if_mib|
|tplink | TP-LINK | TPLINK-SYSINFO-MIB,HOST-RESOURCES-MIB,SNMPv2-MIB,TPLINK-SYSMONITOR-MIB,IF-MIB | T2600G-28TS | https://www.tp-link.com/en/support/download/t2600g-28ts/#MIBs_Files https://www.tp-link.com/ru/support/faq/1330/ |system,if_mib|
|ubiquiti_airos | Ubiquiti AirOS | FROGFOOT-RESOURCES-MIB,HOST-RESOURCES-MIB,SNMPv2-MIB,IEEE802dot11-MIB,IF-MIB | NanoStation M5, UAP-LR |  |system,if_mib,ubiquiti_airos|

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/snmp-observ-lib
```

## Example


## Links
https://cric.grenoble.cnrs.fr/Administrateurs/Outils/MIBS/?oid=1.3.6.1.2.1.2.2.1.3