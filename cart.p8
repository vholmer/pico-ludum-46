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
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000777070700000700070707070777007707770770077700000770000007000777007007070777077007770707077007070000000000000
00000000000000000000707070700000700070707070707070007070070070700000770000007000070070707070070070707000707070707070000000000000
00000000000000000000770077700000700070707700777077707070070077700000770000007000070070707070070070707700707070707700000000000000
00000000000000000000707000700000700070707070707000707070070070700000707000007000070077007070070070707000707070707070000000000000
00000000000000000000777077700000777007707070707077007770777077700000777000007770777007700770777077707000077070707070000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000333333333333333333333333333333300000000033333333333333333333333333333333333333333333000000000000000
00000000000000000000000000000333333333333333333333333333333300000000033333333333333333333333333333333333333333333000000000000000
00000000000000000000000000000333333333333333333333333333333300000000033333333333333333333333333333333333333333333000000000000000
00000000000000000000000003333333bbbbbbbbbbbbbbbbbbbbbbbbb333333000000333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb333000000000000000
00000000000000000000000003333333bbbbbbbbbbbbbbbbbbbbbbbbb333333000000333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb333000000000000000
00000000000000000000000003333333bbbbbbbbbbbbbbbbbbbbbbbbb333333000000333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb333000000000000000
00000000000000000000003333333bbbbbb3333333333333333333bbb333333000000333bbb3333333333333bbbbbb3333333333333bbb333000000000000000
00000000000000000000003333333bbbbbb3333333333333333333bbb333333000000333bbb3333333333333bbbbbb3333333333333bbb333000000000000000
00000000000000000000003333333bbbbbb3333333333333333333bbb333333000000333bbb3333333333333bbbbbb3333333333333bbb333000000000000000
0000000000000000000000333bbbbbbb33333300000000000033333333333330000003333333333000000333bbbbbb3330000000333333333000000000000000
0000000000000000000000333bbbbbbb33333300000000000033333333333330000003333333333000000333bbbbbb3330000000333333333000000000000000
0000000000000000000000333bbbbbbb33333300000000000033333333333330000003333333333000000333bbbbbb3330000000333333333000000000000000
0000000000000000000333333bbbb33333300000000000000000000000000000000000000000000000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333333bbbb33333300000000000000000000000000000000000000000000000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333333bbbb33333300000000000000000000000000000000000000000000000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088888888888800008880000008880008888888888000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088888888888800008880000008880008888888888000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088888888888800008880000008880008888888888000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088800000088800008888880008880008880000000888000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088800000088800008888880008880008880000000888000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088800000088800008888880008880008880000000888000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088888888888800008880008888880008880000000888000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088888888888800008880008888880008880000000888000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088888888888800008880008888880008880000000888000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088800000088800008880000008880008888888888000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088800000088800008880000008880008888888888000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333bbbbbbb33300000088800000088800008880000008880008888888888000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333333bbbb33333300000000000000000000000000000000000000000000000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333333bbbb33333300000000000000000000000000000000000000000000000000333bbbbbb3330000000000000000000000000000000
0000000000000000000333333bbbb33333300000000000000000000000000000000000000000000000000333bbbbbb3330000000000000000000000000000000
0000000000000000000000333bbbbbbb33333300000000000033333333333330000000000000000000000333bbbbbb3330000000000000000000000000000000
0000000000000000000000333bbbbbbb33333300000000000033333333333330000000000000000000000333bbbbbb3330000000000000000000000000000000
0000000000000000000000333bbbbbbb33333300000000000033333333333330000000000000000000000333bbbbbb3330000000000000000000000000000000
00000000000000000000003333333bbbbbb3333333333333333333bbb3333330000000000000000333333333bbbbbb3333333333000000000000000000000000
00000000000000000000003333333bbbbbb3333333333333333333bbb3333330000000000000000333333333bbbbbb3333333333000000000000000000000000
00000000000000000000003333333bbbbbb3333333333333333333bbb3333330000000000000000333333333bbbbbb3333333333000000000000000000000000
00000000000000000000000003333333bbbbbbbbbbbbbbbbbbbbbbbbb3333330000000000003333bbbbbbbbbbbbbbbbbbbbbbbbb333000000000000000000000
00000000000000000000000003333333bbbbbbbbbbbbbbbbbbbbbbbbb3333330000000000003333bbbbbbbbbbbbbbbbbbbbbbbbb333000000000000000000000
00000000000000000000000003333333bbbbbbbbbbbbbbbbbbbbbbbbb3333330000000000003333bbbbbbbbbbbbbbbbbbbbbbbbb333000000000000000000000
00000000000000000000000000000333333333333333333333333333333300000000000000033333333333333333333333333333333000000000000000000000
00000000000000000000000000000333333333333333333333333333333300000000000000033333333333333333333333333333333000000000000000000000
00000000000000000000000000000333333333333333333333333333333300000000000000033333333333333333333333333333333000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000008808880888088808080888088800000880000008880888088800880888000000000000000000000000000000000
00000000000000000000000000000000000080008080808008008080808080000000880000000800808080808000800000000000000000000000000000000000
00000000000000000000000000000000000080008880888008008080880088000000880000000800880088808000880000000000000000000000000000000000
00000000000000000000000000000000000080008080800008008080808080000000808000000800808080808000800000000000000000000000000000000000
00000000000000000000000000000000000008808080800008000880808088800000888000000800808080800880888000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000088808880880088000000888080808880000008808880888008808880880088808000000008808880888088808880880088808880000000000
00000000000000080000800808080800000080080808000000080808080080080000800808080808000000080008080808080008080808080008080000000000
00000000000000088000800808080800000080088808800000080808800080080000800808088808000000088808880880088008880808088008800000000000
00000000000000080000800808080800000080080808000000080808080080080800800808080808000000000808000808080008080808080008080000000000
00000000000000080008880808088800000080080808880000088008080888088808880808080808880000088008000808088808080888088808080000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000088808880888008808880888000008880800080000000888088808880000088808800888088800880888088808800000000000000000000000
00000000000000080808000800080808080800000008080800080000000808080808000000008008080800080008000080080008080000000000000000000000
00000000000000088008800880080808800880000008880800080000000888088008800000008008080880088008000080088008080000000000000000000000
00000000000000080808000800080808080800000008080800080000000808080808000000008008080800080008000080080008080000000000000000000000
00000000000000088808880800088008080888000008080888088800000808080808880000088808080800088800880080088808880000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000008808880888088808080888088800000088088808880888088808880880008800000888088000000808088808000800000000000000000000
00000000000000080008080808008008080808080000000800008000800080000808000808080000000080080800000808080808000800000000000000000000
00000000000000080008880888008008080880088000000800008000800080008008800808088800000080080800000888088808000800000000000000000000
00000000000000080008080800008008080808080000000800008000800080080008000808000800000080080800000808080808000800000000000000000000
00000000000000008808080800008000880808088800000088088800800888088808880808088000000888080800000808080808880888000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000088808880888008808880000088808080888000008880880088808880088088808880088088000000888008808080888088800000000000000
00000000000000008008080808080008000000008008080800000000800808080008000800008000800808080800000808080808080080080000000000000000
00000000000000008008800888080008800000008008880880000000800808088008800800008000800808080800000880080808080080088000000000000000
00000000000000008008080808080008000000008008080800000000800808080008000800008000800808080800000808080808080080080000000000000000
00000000000000008008080808008808880000008008080888000008880808080008880088008008880880080800000808088000880080088800000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000088808080000008808000888008808080888088000880000088808880888008808880000000000000000000000000000000000000000000000
00000000000000080808080000080008000080080008080080080808000000008008080808080008000000000000000000000000000000000000000000000000
00000000000000088008880000080008000080080008800080080808000000008008800888080008800000000000000000000000000000000000000000000000
00000000000000080800080000080008000080080008080080080808080000008008080808080008000000000000000000000000000000000000000000000000
00000000000000088808880000008808880888008808080888080808880000008008080808008808880000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000088808800880000008880808088808800000088800000088088808880888080808880888088000000088088008880000000000000000000000
00000000000000080808080808000000800808080008080000080800000800080808080080080808080800080800000808080808000000000000000000000000
00000000000000088808080808000000800888088008080000088800000800088808880080080808800880080800000808080808800000000000000000000000
00000000000000080808080808000000800808080008080000080800000800080808000080080808080800080800000808080808000000000000000000000000
00000000000000080808080888000000800808088808080000080800000088080808000080008808080888088800000880080808880000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000088080008880088080800000888088008080808080808880888088800000888008800000888088800880888088000000000000000000
00000000000000000000800080000800800080800000808080808080808080808000808080000000080080800000808080008000080080800000000000000000
00000000000000000000800080000800800088000000888080808880808088808800880088000000080080800000880088008000080080800000000000000000
00000000000000000000800080000800800080800000808080800080888080808000808080000000080080800000808080008080080080800000000000000000
00000000000000000000088088808880088080800000808080808880888080808880808088800000080088000000888088808880888080800000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
010100000f0000f0000f000100001000010000100000f000170000e000180000d000180000c0000b000180000b000180000c0000d0000c0000b0000a0000900007000060001b0000400001000000000000000000
010f00000c0330c0032d0032e0030c033260032d0032e0030c0330c00327003220030c0332400322003220030c0330c00327003270030c03324003220031f0030c0331f0031f003000030c033000030000300003
010f00000711507125071450711507125071450711507125071150712507145071150712507145071150712507115071250714507115071250714507115071250711507125071450711507125071450711507125
010f00000211502125021450211502125021450211502125021150212502145021150212502145021150212502115021250214502115021250214502115021250211502125021450211502125021450211502125
010f00002211522125221452211503125031450311503125031150312503145031150312503145031150312503115031250314503115031250314503115031250311503125031450311503125031450311503125
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
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
00 41424647
00 41484447
00 41424344
01 41504d0f
02 4151430f

