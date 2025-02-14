# SNMP observability library

This lib can be used to generate dashboards, rows, panels for SNMP devices.

The library supports multiple metrics sources (`metricsSource`).

### Supported sources

|metricsSource|Description|MIBs|Known devices|Links|snmp_exporter modules|
|-|-|-|-|-|-|
|generic           |Generic SNMP device|IF-MIB,SNMPv2-MIB    |default choice||system,if_mib,hrDevice,hrStorage|
|cisco             | Cisco IoS devices |IF-MIB,SNMPv2-MIB, Cisco private mibs|-|Cisco C2900, Cisco C7600, Cisco MDS|system,if_mib,cisco_device,cisco_fc_fe|
|arista_sw            | Arista devices    |IF-MIB,SNMPv2-MIB,HOST-RESOURCES-MIB|-||system,if_mib,hrDevice,hrStorage,arista_sw|
|brocade_fcs       | Brocade           |IF-MIB,SNMPv2-MIB,SW-MIB|Brocade 6520 v7.4.1c, Brocade 300 v7.0.0c,Brocade BL 5480 v6.3.1c|https://techdocs.broadcom.com/us/en/fibre-channel-networking/fabric-os/fabric-os-mib/9-1-x/understanding-brocade-snmp/loading-brocade-mibs/brocade-mib-files.html|system,if_mib|
|brocade_foundry | Brocade Foundry | FOUNDRY-SN-AGENT-MIB | Brocade MLXe (System Mode: MLX), IronWare Version V5.4.0eT163, Foundry FLS648 Foundry Networks, Inc. FLS648, IronWare Version 04.1.00bT7e1, Foundry FWSX424 Foundry Networks, Inc. FWSX424, IronWare Version 02.0.00aT1e0||system,if_mib|
|dell_network | Dell Force S-Series, Dell Force10 MXL 10 | IF-MIB,SNMPv2-MIB,DELL-NETWORKING-CHASSIS-MIB | Dell Force S-Series |https://www.dell.com/support/kbdoc/en-us/000181922/dell-networking-mibs|system,if_mib,dell_network|
|dlink_des | D-Link DES series | IF-MIB,SNMPv2-MIB,AGENT-GENERAL-MIB | DGS-3420-26SC Gigabit Ethernet ||system,if_mib,dlink|
|eltex_mes | Eltex MES | IF-MIB, SNMPv2-MIB,ELTEX-MES-ISS-CPU-UTIL-MIB,ARICENT-ISS-MIB | MES 2448P ||system,if_mib,eltex_mes|
|extreme | ExtremeXOS | IF-MIB, SNMPv2-MIB,EXTREME-SYSTEM-MIB, EXTREME-SOFTWARE-MONITOR-MIB | - ||system,if_mib|
|f5_bigip | F5 BigIP | IF-MIB,SNMPv2-MIB,F5-BIGIP-SYSTEM-MIB | - |https://my.f5.com/manage/s/article/K13322|system,if_mib|
|fortigate | Fortinet Fortigate | IF-MIB,SNMPv2-MIB,FORTINET-FORTIGATE-MIB,ENTITY-MIB | v7.2.5 ||system,if_mib,hrDevice,hrStorage|
|hpe | HP Enterprise Switches | IF-MIB,SNMPv2-MIB,STATISTICS-MIB,NETSWITCH-MIB | HP ProCurve J4900B, HP J9728A 2920-48G | https://support.hpe.com/hpesc/public/docDisplay?sp4ts.oid=51079&docId=emr_na-c02597344|system,if_mib|
|huawei | Huawei VRP | IF-MIB,SNMPv2-MIB,HUAWEI-ENTITY-EXTENT-MIB | - |https://support.huawei.com/enterprise/en/doc/EDOC1000178181/2f6c0513/mib-overview |system,if_mib|
|juniper | Juniper MX, Juniper SRX | IF-MIB,SNMPv2-MIB,JUNIPER-MIB,JUNIPER-ALARM-MIB | Juniper MX204 Edge Router, JUNOS 24.2R1-S1.10, Juniper SRX, Juniper EX4200-24| https://www.juniper.net/documentation/us/en/software/nce/nce-srx-cluster-management-best/topics/concept/chassis-cluster-performance-monitoring.html |system,if_mib|
|mikrotik | Mikrotik OS | HOST-RESOURCES-MIB,SNMPv2-MIB,MIKROTIK-MIB,IF-MIB | Router OS 7.3 |912UAG-5HPnD,941-2nD,1100ahx2,CCR1016-12G,CCR1036-12G-4S,rb2011ua,mikrotik450g,mikrotikrb1100ah|system,if_mib,mikrotik,hrStorage,hrDevice|
|netgear | Netgear FastPath switches | SNMPv2-MIB,FASTPATH-SWITCHING-MIB,FASTPATH-BOXSERVICES-PRIVATE-MIB,IF-MIB | Netgear M5300-28G | https://kb.netgear.com/24352/MIBs-for-Smart-switches |system,if_mib,netgear|
|qtech | QTech | QTECH-MIB,EtherLike-MIB,HOST-RESOURCES-MIB,SNMPv2-MIB,ENTITY-MIB,IF-MIB | | |system,if_mib|
|tplink | TP-LINK | TPLINK-SYSINFO-MIB,HOST-RESOURCES-MIB,SNMPv2-MIB,TPLINK-SYSMONITOR-MIB,IF-MIB | T2600G-28TS | https://www.tp-link.com/en/support/download/t2600g-28ts/#MIBs_Files https://www.tp-link.com/ru/support/faq/1330/ |system,if_mib|
|ubiquiti_airos | Ubiquiti AirOS | FROGFOOT-RESOURCES-MIB,HOST-RESOURCES-MIB,SNMPv2-MIB,IEEE802dot11-MIB,IF-MIB | NanoStation M5, UAP-LR |  |system,if_mib,ubiquiti_airos|

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/snmp-observ-lib
```

## Usage

For detailed usage examples see [helloworld-observ-lib README](../helloworld-observ-lib/README.md).
