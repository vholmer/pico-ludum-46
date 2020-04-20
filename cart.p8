pico-8 cartridge // http://www.pico-8.com
version 21
__lua__
#include lua/globals.lua
#include lua/main.lua
#include lua/draw.lua
#include lua/make.lua
#include lua/priority-queue.lua
#include lua/a-star.lua
#include lua/game.lua
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000033333333330003333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000033bbbbbbbb33003bbbbbbbbbbbb300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000033bb333333b33003b3333bb3333b300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000003bb330000333300333003bb30033300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700033b3300000000000000003bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003bb3008888080080888003bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003bb3008008088080800803bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003bb3008888080880800803bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000003bb3008008080080888003bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000033b3300000000000000003bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000003bb330000333300000003bb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000033bb333333b3300000333bb33300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000033bbbbbbbb3300003bbbbbbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000033333333330000033333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000f0000f0000f000100001000010000100000f000170000e000180000d000180000c0000b000180000b000180000c0000d0000c0000b0000a0000900007000060001b0000400001000000000000000000
010f00000c0330c0032d0032e0030c033260032d0032e0030c0330c00327003220030c0332400322003220030c0330c00327003270030c03324003220031f0030c0331f0031f003000030c033000030000300003
010f00000711507125071450711507125071450711507125071150712507145071150712507145071150712507115071250714507115071250714507115071250711507125071450711507125071450711507125
010f00000211502125021450211502125021450211502125021150212502145021150212502145021150212502115021250214502115021250214502115021250211502125021450211502125021450211502125
010f00000311503125031450311503125031450311503125031150312503145031150312503145031150312503115031250314503115031250314503115031250311503125031450311503125031450311503125
010f0000277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725
011000001e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e7101e710
011000001f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f7101f710
010f00000511505125051450511505125051450511505125051150512505145051150512505145051150512505115051250514505115051250514505115051250511505125051450511505125051450511502125
010f00000011500115001350011500115001150013500115001150011500135001150011500115001350015500115001150013500115001150011500135001150011500115001350011500115001150013500155
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725277351f715267351f725
011000000711207112071120711207112071120711207112071120711207112071120711207112071120711207112071120711207112071120711207112071120711207112071120711207112071120711207112
011000000a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a1120a112
011000000705507015070250701500005000050000500005070550701507025070150000500005000050000507055070150702507015000050000500005000050705507015070250701500005000050000500005
0110000026710267202d7402e71026720267402d7102e72026710267202d7402e71026720267402d7102e72027710277202d7402e71027720277402d7102e72026710267202d7402e71026720267402d7102e720
0110000026710267202d7402e71026720267402d7102e72026710267202d7402e71026720267402d7102e72027710277202d7402e71027720277402d7102e72029710297202d7402e71029720297402d7102e720
00070000015100352004530065400a5500e56012570165702f500225001b50016500165000a500005000a50003500005000050001500015000150000500005000050000500005000050000500005000050000500
00060000275351f515265351f525275351f515265351f525275351f515265351f525275351f515265351f525275351f515265351f525275051f505265051f505275051f505265051f505275051f505265051f505
000600002e5502c5502a540265401f530185200f50000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
010500003b510395303754035510325302d540255101b50000500205001f5001d500005001a500005001650000500125000e50000500005000050000500005000050000500005000050000500005000050000500
0110000017050160501505014050130501205011050100500f0500e0500d0500c0500b0500a050090500805013000120001100010000000000000000000000000000000000000000000000000000000000000000
001000002075024750227501f7501d7501b7501875018750187501b7501d750227502775000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700
011000000701207052070120705207012070520701207052130520705207052070520705200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002
__music__
00 41424345
00 41024346
00 41025046
01 01024345
00 01044347
00 01034344
00 01024344
00 01034344
00 01044344
00 01024344
00 01024345
00 01034342
00 01044346
00 01084347
00 01024344
02 01024345
00 41434345
00 41444345
00 13424647
00 41484447
00 41424344
01 41504d0f
02 4151430f

