; O731 Falco Infinity: static linear disassembly of keyboard-relevant routines
; Reconstructed address banks: ROM0 fixed upper half, ROM0 bank1 4000-7FFF, ROM1 bank2 0000-3FFF
; Caution: not a verified control-flow disassembler; some sections contain multiple jump targets.
; Raw bytes follow each address.


; ===== Keyboard initialization / Falco vs PC mapping selection; bank 1 =====
80B0: 4f                LD C,A
80B1: 3a 50 c0          LD A,(0xC050)
80B4: fe 0e             CP 0x0E
80B6: d4 ef 3e          CALL NC,0x3EEF
80B9: 21 b5 a1          LD HL,0xA1B5
80BC: cd 24 77          CALL 0x7724
80BF: 22 d5 c8          LD (0xC8D5),HL
80C2: 21 51 93          LD HL,0x9351
80C5: cb 59             BIT 3,C
80C7: 20 03             JR NZ,0x80CC
80C9: 21 48 95          LD HL,0x9548
80CC: 11 38 c0          LD DE,0xC038
80CF: 01 06 00          LD BC,0x0006
80D2: ed b0             LDIR
80D4: 7e                LD A,(HL)
80D5: 23                INC HL
80D6: 4f                LD C,A
80D7: 3c                INC A
80D8: 32 3e c0          LD (0xC03E),A
80DB: 11 4c c7          LD DE,0xC74C
80DE: cd 86 81          CALL 0x8186
80E1: 3a 0e c0          LD A,(0xC00E)
80E4: e6 38             AND 0x38
80E6: fe 08             CP 0x08
80E8: 28 0a             JR Z,0x80F4
80EA: 3a 4c c0          LD A,(0xC04C)
80ED: cb bf             RES 7,A
80EF: 32 4c c0          LD (0xC04C),A
80F2: 18 15             JR 0x8109
80F4: 3a 4c c0          LD A,(0xC04C)
80F7: cb 7f             BIT 7,A
80F9: 28 0e             JR Z,0x8109
80FB: e5                PUSH HL
80FC: 11 4f c7          LD DE,0xC74F
80FF: 01 19 00          LD BC,0x0019
8102: 21 c9 94          LD HL,0x94C9
8105: cd 86 81          CALL 0x8186
8108: e1                POP HL
8109: dd e5             PUSH IX
810B: dd 2a d5 c8       LD IX,(0xC8D5)
810F: 11 01 00          LD DE,0x0001
8112: 3a 0e c0          LD A,(0xC00E)
8115: cb 5f             BIT 3,A
8117: 20 03             JR NZ,0x811C
8119: 11 07 00          LD DE,0x0007
811C: dd 19             ADD IX,DE
811E: dd 66 01          LD H,(IX+1)
8121: dd 6e 00          LD L,(IX+0)
8124: 22 c9 c8          LD (0xC8C9),HL
8127: dd 66 03          LD H,(IX+3)
812A: dd 6e 02          LD L,(IX+2)
812D: cd 70 81          CALL 0x8170
8130: dd 66 05          LD H,(IX+5)
8133: dd 6e 04          LD L,(IX+4)
8136: cd 70 81          CALL 0x8170
8139: dd 2a d5 c8       LD IX,(0xC8D5)
813D: dd 7e 00          LD A,(IX+0)
8140: 32 c6 c8          LD (0xC8C6),A
8143: dd e3             EX (SP),IX
8145: e1                POP HL
8146: 11 0d 00          LD DE,0x000D
8149: 19                ADD HL,DE
814A: 11 cb c8          LD DE,0xC8CB
814D: 01 0a 00          LD BC,0x000A
8150: ed b0             LDIR
8152: cd 97 52          CALL 0x5297
8155: cd 83 5e          CALL 0x5E83
8158: 22 c7 c8          LD (0xC8C7),HL
815B: 11 ef 5b          LD DE,0x5BEF
815E: 3a 50 c0          LD A,(0xC050)
8161: fe 00             CP 0x00
8163: cc 73 30          CALL Z,0x3073
8166: c9                RET
8167: cd 8f 3a          CALL 0x3A8F
816A: 32 ff c0          LD (0xC0FF),A
816D: c3 ad 3a          JP 0x3AAD
8170: 06 00             LD B,0x00
8172: 7e                LD A,(HL)
8173: 23                INC HL
8174: b7                OR A
8175: c8                RET Z
8176: 4e                LD C,(HL)
8177: 23                INC HL
8178: eb                EX DE,HL
8179: 21 4c c7          LD HL,0xC74C
817C: 09                ADD HL,BC
817D: 09                ADD HL,BC
817E: 09                ADD HL,BC
817F: 4f                LD C,A
8180: eb                EX DE,HL
8181: cd 86 81          CALL 0x8186
8184: 18 ec             JR 0x8172
8186: e5                PUSH HL
8187: 06 00             LD B,0x00
8189: 60                LD H,B
818A: 69                LD L,C
818B: 09                ADD HL,BC
818C: 09                ADD HL,BC
818D: 44                LD B,H
818E: 4d                LD C,L
818F: e1                POP HL
8190: ed b0             LDIR
8192: c9                RET

; ===== Keyboard input and scan code translation; bank 2 =====
8074: fd cb 82 46       BIT 0,(IY-126)
8078: 20 1e             JR NZ,0x8098
807A: dd e5             PUSH IX
807C: dd 2a 22 c2       LD IX,(0xC222)
8080: db 50             IN A,(0x50)
8082: 4f                LD C,A
8083: 3e 40             LD A,0x40
8085: d3 5b             OUT (0x5B),A
8087: cd 94 41          CALL 0x4194
808A: 20 03             JR NZ,0x808F
808C: cd 4e 05          CALL 0x054E
808F: 79                LD A,C
8090: c4 99 80          CALL NZ,0x8099
8093: cd 1f 05          CALL 0x051F
8096: dd e1             POP IX
8098: c9                RET
8099: cd a2 41          CALL 0x41A2
809C: cd ee 41          CALL 0x41EE
809F: d8                RET C
80A0: 32 12 c0          LD (0xC012),A
80A3: e6 7f             AND 0x7F
80A5: c8                RET Z
80A6: fd be be          CP (IY-66)
80A9: d2 fa 81          JP NC,0x81FA
80AC: 4f                LD C,A
80AD: 3a 12 c0          LD A,(0xC012)
80B0: cd 58 42          CALL 0x4258
80B3: 79                LD A,C
80B4: cd 02 41          CALL 0x4102
80B7: fd cb 81 6e       BIT 5,(IY-127)
80BB: 28 04             JR Z,0x80C1
80BD: 23                INC HL
80BE: 23                INC HL
80BF: 18 1d             JR 0x80DE
80C1: 3a 0f c0          LD A,(0xC00F)
80C4: e6 12             AND 0x12
80C6: 28 04             JR Z,0x80CC
80C8: 23                INC HL
80C9: 23                INC HL
80CA: 18 12             JR 0x80DE
80CC: 3a 0f c0          LD A,(0xC00F)
80CF: e6 09             AND 0x09
80D1: 20 0a             JR NZ,0x80DD
80D3: 7e                LD A,(HL)
80D4: fe ba             CP 0xBA
80D6: 30 06             JR NC,0x80DE
80D8: cd 34 41          CALL 0x4134
80DB: 28 01             JR Z,0x80DE
80DD: 23                INC HL
80DE: 46                LD B,(HL)
80DF: 3a 12 c0          LD A,(0xC012)
80E2: e6 80             AND 0x80
80E4: 28 34             JR Z,0x811A
80E6: 78                LD A,B
80E7: fd cb 8e 7e       BIT 7,(IY-114)
80EB: 28 07             JR Z,0x80F4
80ED: fe a0             CP 0xA0
80EF: 38 03             JR C,0x80F4
80F1: fe a2             CP 0xA2
80F3: d8                RET C
80F4: c5                PUSH BC
80F5: cd fc 81          CALL 0x81FC
80F8: c1                POP BC
80F9: 78                LD A,B
80FA: cb 7f             BIT 7,A
80FC: 28 07             JR Z,0x8105
80FE: e6 7f             AND 0x7F
8100: fe 06             CP 0x06
8102: da 22 41          JP C,0x4122
8105: 3a 10 c0          LD A,(0xC010)
8108: 32 17 c0          LD (0xC017),A
810B: b9                CP C
810C: c0                RET NZ
810D: fd 36 90 00       LD (IY-112),0x00
8111: fd 36 91 00       LD (IY-111),0x00
8115: fd 36 97 00       LD (IY-105),0x00
8119: c9                RET
811A: 78                LD A,B
811B: fd cb 8f 56       BIT 2,(IY-113)
811F: 28 37             JR Z,0x8158
8121: cd 7a 53          CALL 0x537A
8124: 28 32             JR Z,0x8158
8126: fe a0             CP 0xA0
8128: 38 2e             JR C,0x8158
812A: fe a2             CP 0xA2
812C: 30 2a             JR NC,0x8158
812E: fd cb 8e 7e       BIT 7,(IY-114)
8132: 20 08             JR NZ,0x813C
8134: fd cb 8e fe       SET 7,(IY-114)
8138: fd 36 96 00       LD (IY-106),0x00
813C: cd 3e 71          CALL 0x713E
813F: 7e                LD A,(HL)
8140: fe 30             CP 0x30
8142: 38 13             JR C,0x8157
8144: fe 3a             CP 0x3A
8146: 30 0f             JR NC,0x8157
8148: d6 30             SUB 0x30
814A: 47                LD B,A
814B: 3a 16 c0          LD A,(0xC016)
814E: 87                ADD A,A
814F: 4f                LD C,A
8150: 87                ADD A,A
8151: 87                ADD A,A
8152: 81                ADD A,C
8153: 80                ADD A,B
8154: 32 16 c0          LD (0xC016),A
8157: c9                RET
8158: fd 71 90          LD (IY-112),C
815B: cb 7f             BIT 7,A
815D: 20 07             JR NZ,0x8166
815F: 26 00             LD H,0x00
8161: cd 42 41          CALL 0x4142
8164: 18 46             JR 0x81AC
8166: fe ff             CP 0xFF
8168: 20 0e             JR NZ,0x8178
816A: 2b                DEC HL
816B: 3a 0f c0          LD A,(0xC00F)
816E: e6 09             AND 0x09
8170: 20 01             JR NZ,0x8173
8172: 2b                DEC HL
8173: 7e                LD A,(HL)
8174: e6 1f             AND 0x1F
8176: 18 34             JR 0x81AC
8178: fd 36 91 00       LD (IY-111),0x00
817C: fe 91             CP 0x91
817E: 30 2c             JR NC,0x81AC
8180: f5                PUSH AF
8181: e6 7f             AND 0x7F
8183: fd cb 81 6e       BIT 5,(IY-127)
8187: 20 12             JR NZ,0x819B
8189: cd 4f 42          CALL 0x424F
818C: 28 0d             JR Z,0x819B
818E: fe 09             CP 0x09
8190: 38 09             JR C,0x819B
8192: fd cb 8f 6e       BIT 5,(IY-113)
8196: 20 03             JR NZ,0x819B
8198: f1                POP AF
8199: 18 11             JR 0x81AC
819B: cd 28 41          CALL 0x4128
819E: fd 36 93 ff       LD (IY-109),0xFF
81A2: 22 14 c0          LD (0xC014),HL
81A5: cd fc 77          CALL 0x77FC
81A8: f1                POP AF
81A9: c3 fc 81          JP 0x81FC
81AC: 32 13 c0          LD (0xC013),A
81AF: cd fc 81          CALL 0x81FC
81B2: cd 64 41          CALL 0x4164
81B5: ca 48 03          JP Z,0x0348
81B8: fd 36 91 0f       LD (IY-111),0x0F
81BC: c9                RET
81BD: f5                PUSH AF
81BE: 3a 11 c0          LD A,(0xC011)
81C1: b7                OR A
81C2: 28 34             JR Z,0x81F8
81C4: 3d                DEC A
81C5: 20 2e             JR NZ,0x81F5
81C7: 3a 10 c0          LD A,(0xC010)
81CA: 32 17 c0          LD (0xC017),A
81CD: 3a 13 c0          LD A,(0xC013)
81D0: fe ff             CP 0xFF
81D2: 28 09             JR Z,0x81DD
81D4: 21 02 c0          LD HL,0xC002
81D7: cb 46             BIT 0,(HL)
81D9: 28 02             JR Z,0x81DD
81DB: f1                POP AF
81DC: c9                RET
81DD: e5                PUSH HL
81DE: d5                PUSH DE
81DF: c5                PUSH BC
81E0: fe ff             CP 0xFF
81E2: 28 05             JR Z,0x81E9
81E4: cd fc 81          CALL 0x81FC
81E7: 18 06             JR 0x81EF
81E9: 2a 14 c0          LD HL,(0xC014)
81EC: cd fc 77          CALL 0x77FC
81EF: c1                POP BC
81F0: d1                POP DE
81F1: e1                POP HL
81F2: cd 59 41          CALL 0x4159
81F5: 32 11 c0          LD (0xC011),A
81F8: f1                POP AF
81F9: c9                RET
81FA: 3e 86             LD A,0x86
81FC: fd 5e 92          LD E,(IY-110)
81FF: c3 a5 1c          JP 0x1CA5

; ===== Physical scan -> three-byte table entry pointer; bank 1 =====
4102: 4f                LD C,A
4103: 06 00             LD B,0x00
4105: 21 4c c7          LD HL,0xC74C
4108: 09                ADD HL,BC
4109: 09                ADD HL,BC
410A: 09                ADD HL,BC
410B: c9                RET

; ===== Related Caps and modifier selection helper; bank 1 =====
412E: 3a 0f c0          LD A,(0xC00F)
4131: e6 09             AND 0x09
4133: c0                RET NZ
4134: 3a 02 c0          LD A,(0xC002)
4137: cb 77             BIT 6,A
4139: 28 02             JR Z,0x413D
413B: 97                SUB A
413C: c9                RET
413D: dd cb 4c 76       BIT 6,(IX+76)
4141: c9                RET

; ===== Keyboard input status and acknowledgment; bank 1 =====
0305: 3e 07             LD A,0x07
0307: d3 58             OUT (0x58),A
0309: cd 4c 06          CALL 0x064C
030C: 3e 40             LD A,0x40
030E: d3 5b             OUT (0x5B),A
0310: 3e 0f             LD A,0x0F
0312: d3 58             OUT (0x58),A
0314: c9                RET
0315: 3e 00             LD A,0x00
0317: d3 58             OUT (0x58),A
0319: c9                RET
031A: 3e 40             LD A,0x40
031C: d3 5b             OUT (0x5B),A
031E: 3e 08             LD A,0x08
0320: d3 58             OUT (0x58),A
0322: c9                RET
0323: 16 c8             LD D,0xC8
0325: db 51             IN A,(0x51)
0327: cb 67             BIT 4,A
0329: 28 09             JR Z,0x0334
032B: db 50             IN A,(0x50)
032D: 57                LD D,A
032E: 3e 40             LD A,0x40
0330: d3 5b             OUT (0x5B),A
0332: 7a                LD A,D
0333: c9                RET
0334: cd 4c 06          CALL 0x064C
0337: 15                DEC D
0338: 20 eb             JR NZ,0x0325
033A: c9                RET
