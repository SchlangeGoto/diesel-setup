# Hardware snapshot

Generated: 2026-11-17T11:08:32+01:00

## System
```
Linux diesel 7.3.4-arch1-2 #1 SMP PREEMPT_DYNAMIC Thu, 12 Nov 2026 20:11:37 +0000 x86_64 GNU/Linux
```

## CPU
```
Architecture:                            x86_64
CPU op-mode(s):                          32-bit, 64-bit
Address sizes:                           48 bits physical, 48 bits virtual
Byte Order:                              Little Endian
CPU(s):                                  24
On-line CPU(s) list:                     0-23
Vendor ID:                               AuthenticAMD
Model name:                              AMD Ryzen AI 9 HX 370 w/ Radeon 890M
CPU family:                              26
Model:                                   36
Thread(s) per core:                      2
Core(s) per socket:                      12
Socket(s):                               1
Stepping:                                0
Microcode version:                       0xb204037
Frequency boost:                         enabled
CPU(s) scaling MHz:                      53%
CPU max MHz:                             2000,0000
CPU min MHz:                             605,2640
BogoMIPS:                                3992,28
Flags:                                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good amd_lbr_v2 nopl xtopology nonstop_tsc cpuid extd_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpuid_fault cpb cat_l3 cdp_l3 hw_pstate ssbd mba perfmon_v2 ibrs ibpb stibp ibrs_enhanced vmmcall fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local user_shstk avx_vnni avx512_bf16 clzero irperf xsaveerptr rdpru wbnoinvd cppc arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif x2avic v_spec_ctrl vnmi avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid bus_lock_detect movdiri movdir64b overflow_recov succor smca fsrm avx512_vp2intersect flush_l1d amd_lbr_pmc_freeze
Virtualization:                          AMD-V
L1d cache:                               576 KiB (12 instances)
L1i cache:                               384 KiB (12 instances)
L2 cache:                                12 MiB (12 instances)
L3 cache:                                24 MiB (2 instances)
NUMA node(s):                            1
NUMA node0 CPU(s):                       0-23
Vulnerability Gather data sampling:      Not affected
Vulnerability Ghostwrite:                Not affected
```

## PCI
```
00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Root Complex [1022:1507]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Root Complex [1022:1507]
00:00.2 IOMMU [0806]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo IOMMU [1022:1508]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo IOMMU [1022:1508]
00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Dummy Host Bridge [1022:1509]
00:01.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo PCIe USB4 Bridge [1022:150a]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo PCIe USB4 Bridge [1022:150a]
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Dummy Host Bridge [1022:1509]
00:02.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo GPP Bridge [1022:150b]
	Subsystem: ASUSTeK Computer Inc. Device [1043:1ee3]
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00:02.3 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo GPP Bridge [1022:150b]
	Subsystem: ASUSTeK Computer Inc. Device [1043:1ee3]
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00:03.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Dummy Host Bridge [1022:1509]
00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Dummy Host Bridge [1022:1509]
00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Internal GPP Bridge to Bus [C:A] [1022:150c]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Internal GPP Bridge to Bus [C:A] [1022:150c]
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00:08.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Internal GPP Bridge to Bus [C:A] [1022:150c]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Internal GPP Bridge to Bus [C:A] [1022:150c]
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00:08.3 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Internal GPP Bridge to Bus [C:A] [1022:150c]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo Internal GPP Bridge to Bus [C:A] [1022:150c]
	Kernel driver in use: pcieport
	Kernel modules: shpchp
00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:790b] (rev 71)
	Subsystem: ASUSTeK Computer Inc. Device [1043:1ee3]
	Kernel driver in use: piix4_smbus
	Kernel modules: i2c_piix4, sp5100_tco
00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:790e] (rev 51)
	Subsystem: ASUSTeK Computer Inc. Device [1043:1ee3]
00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix Data Fabric; Function 0 [1022:16f8]
00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix Data Fabric; Function 1 [1022:16f9]
00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix Data Fabric; Function 2 [1022:16fa]
00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix Data Fabric; Function 3 [1022:16fb]
	Kernel driver in use: k10temp
	Kernel modules: k10temp
00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix Data Fabric; Function 4 [1022:16fc]
00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix Data Fabric; Function 5 [1022:16fd]
00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix Data Fabric; Function 6 [1022:16fe]
00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Strix Data Fabric; Function 7 [1022:16ff]
61:00.0 Non-Volatile memory controller [0108]: Sandisk Corp WD SN560/SN740/SN770/SN5000 NVMe SSD [15b7:5017] (rev 01)
	Subsystem: Sandisk Corp WD SN560/SN740/SN770/SN5000 NVMe SSD [15b7:5017]
	Kernel driver in use: nvme
	Kernel modules: nvme
62:00.0 Network controller [0280]: MEDIATEK Corp. MT7922 802.11ax PCI Express Wireless Network Adapter [14c3:0616]
	Subsystem: Foxconn International, Inc. Device [105b:e0de]
	Kernel driver in use: mt7921e
	Kernel modules: mt7921e
63:00.0 Display controller [0380]: Advanced Micro Devices, Inc. [AMD/ATI] Strix [Radeon 880M / 890M] [1002:150e] (rev c1)
	Subsystem: ASUSTeK Computer Inc. Device [1043:38b8]
	Kernel driver in use: amdgpu
	Kernel modules: amdgpu
63:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Radeon High Definition Audio Controller [1002:1640]
	Subsystem: Advanced Micro Devices, Inc. [AMD/ATI] Radeon High Definition Audio Controller [1002:1640]
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel
63:00.2 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Strix/Krackan/Strix Halo CCP/ASP [1022:17e0]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Strix/Krackan/Strix Halo CCP/ASP [1022:17e0]
	Kernel driver in use: ccp
	Kernel modules: ccp
63:00.4 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device [1022:151e]
	Subsystem: ASUSTeK Computer Inc. Device [1043:201f]
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci
63:00.5 Multimedia controller [0480]: Advanced Micro Devices, Inc. [AMD] Audio Coprocessor [1022:15e2] (rev 70)
	Subsystem: Advanced Micro Devices, Inc. [AMD] Audio Coprocessor [1022:15e2]
	Kernel driver in use: snd_acp_pci
	Kernel modules: snd_pci_acp3x, snd_rn_pci_acp3x, snd_pci_acp5x, snd_pci_acp6x, snd_acp_pci, snd_pci_ps, snd_pci_acp7x, snd_sof_amd_renoir, snd_sof_amd_rembrandt, snd_sof_amd_vangogh, snd_sof_amd_acp63, snd_sof_amd_acp70, snd_sof_amd_acp7x
63:00.6 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Ryzen HD Audio Controller [1022:15e3]
	DeviceName: Realtek ALC245
	Subsystem: ASUSTeK Computer Inc. Device [1043:3be0]
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel
64:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo PCIe Dummy Function [1022:150d]
	Subsystem: Advanced Micro Devices, Inc. [AMD] Strix/Strix Halo PCIe Dummy Function [1022:150d]
64:00.1 Signal processing controller [1180]: Advanced Micro Devices, Inc. [AMD] Strix/Krackan/Strix Halo Neural Processing Unit [1022:17f0] (rev 10)
	Subsystem: ASUSTeK Computer Inc. Device [1043:20cf]
	Kernel driver in use: amdxdna
	Kernel modules: amdxdna
65:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device [1022:151f]
	Subsystem: ASUSTeK Computer Inc. Device [1043:201f]
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci
65:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device [1022:151a]
	Subsystem: ASUSTeK Computer Inc. Device [1043:201f]
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci
65:00.4 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device [1022:151b]
	Subsystem: ASUSTeK Computer Inc. Device [1043:201f]
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci
65:00.5 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] USB4 Router 0 [1022:151c]
	Subsystem: ASUSTeK Computer Inc. Device [1043:20af]
	Kernel driver in use: thunderbolt
	Kernel modules: thunderbolt
```

## USB
```
(lsusb not installed)
```

## Disks
```
NAME        FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
nvme0n1                                                                            
├─nvme0n1p1 vfat   FAT32 EFI   C212-76CB                                           
├─nvme0n1p2 btrfs        ARCH  53034fdb-cae5-4b7d-bf13-cd367d2b0362    1,2T    15% /home
│                                                                                  /
├─nvme0n1p3                                                                        
├─nvme0n1p4 ntfs               CC66EB1366EAFD58                                    
└─nvme0n1p5 ntfs               5070DD9A70DD86DE                                    
```

## Memory
```
               total        used        free      shared  buff/cache   available
Mem:            30Gi        17Gi       877Mi       870Mi        10Gi        12Gi
Swap:             0B          0B          0B
```

## Filesystems
```
Filesystem     Type      Size  Used Avail Use% Mounted on
/dev/nvme0n1p2 btrfs     1,4T  205G  1,2T  15% /
devtmpfs       devtmpfs  4,0M     0  4,0M   0% /dev
tmpfs          tmpfs      16G  119M   16G   1% /dev/shm
efivarfs       efivarfs  128K   56K   68K  46% /sys/firmware/efi/efivars
tmpfs          tmpfs     6,1G  1,8M  6,1G   1% /run
none           tmpfs     1,0M     0  1,0M   0% /run/credentials/systemd-journald.service
tmpfs          tmpfs      16G  425M   15G   3% /tmp
/dev/nvme0n1p2 btrfs     1,4T  205G  1,2T  15% /home
tmpfs          tmpfs     3,1G   22M  3,1G   1% /run/user/1000
```

## EFI boot entries
```
BootCurrent: 0002
Timeout: 1 seconds
BootOrder: 0002,0000,0001,0003,0004,0005
Boot0000  Windows Boot Manager	HD(1,GPT,0080528e-e883-461a-bb8a-6c1fd8c26258,0x800,0x82000)/\EFI\Microsoft\Boot\bootmgfw.efi57494e444f5753000100000088000000780000004200430044004f0042004a004500430054003d007b00390064006500610038003600320063002d0035006300640064002d0034006500370030002d0061006300630031002d006600330032006200330034003400640034003700390035007d00000000000100000010000000040000007fff0400
      dp: 04 01 2a 00 01 00 00 00 00 08 00 00 00 00 00 00 00 20 08 00 00 00 00 00 8e 52 80 00 83 e8 1a 46 bb 8a 6c 1f d8 c2 62 58 02 02 / 04 04 46 00 5c 00 45 00 46 00 49 00 5c 00 4d 00 69 00 63 00 72 00 6f 00 73 00 6f 00 66 00 74 00 5c 00 42 00 6f 00 6f 00 74 00 5c 00 62 00 6f 00 6f 00 74 00 6d 00 67 00 66 00 77 00 2e 00 65 00 66 00 69 00 00 00 / 7f ff 04 00
    data: 57 49 4e 44 4f 57 53 00 01 00 00 00 88 00 00 00 78 00 00 00 42 00 43 00 44 00 4f 00 42 00 4a 00 45 00 43 00 54 00 3d 00 7b 00 39 00 64 00 65 00 61 00 38 00 36 00 32 00 63 00 2d 00 35 00 63 00 64 00 64 00 2d 00 34 00 65 00 37 00 30 00 2d 00 61 00 63 00 63 00 31 00 2d 00 66 00 33 00 32 00 62 00 33 00 34 00 34 00 64 00 34 00 37 00 39 00 35 00 7d 00 00 00 00 00 01 00 00 00 10 00 00 00 04 00 00 00 7f ff 04 00
Boot0001* GRUB	VenHw(99e275e7-75a0-4b37-a2e6-c5385e6c00cb)
      dp: 01 04 14 00 e7 75 e2 99 a0 75 37 4b a2 e6 c5 38 5e 6c 00 cb / 7f ff 04 00
Boot0002* UEFI OS	HD(1,GPT,0080528e-e883-461a-bb8a-6c1fd8c26258,0x800,0x82000)/\EFI\BOOT\BOOTX64.EFI0000424f
      dp: 04 01 2a 00 01 00 00 00 00 08 00 00 00 00 00 00 00 20 08 00 00 00 00 00 8e 52 80 00 83 e8 1a 46 bb 8a 6c 1f d8 c2 62 58 02 02 / 04 04 30 00 5c 00 45 00 46 00 49 00 5c 00 42 00 4f 00 4f 00 54 00 5c 00 42 00 4f 00 4f 00 54 00 58 00 36 00 34 00 2e 00 45 00 46 00 49 00 00 00 / 7f ff 04 00
    data: 00 00 42 4f
Boot0003* UEFI:CD/DVD Drive	BBS(129,,0x0)
      dp: 05 01 09 00 81 00 00 00 00 / 7f ff 04 00
Boot0004* UEFI:Removable Device	BBS(130,,0x0)
      dp: 05 01 09 00 82 00 00 00 00 / 7f ff 04 00
Boot0005* UEFI:Network Device	BBS(131,,0x0)
      dp: 05 01 09 00 83 00 00 00 00 / 7f ff 04 00
```
