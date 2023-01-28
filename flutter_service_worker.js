'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "flutter.js": "1cfe996e845b3a8a33f57607e8b09ee4",
"index.html": "cf7640b37d2a82e13c99a4ed63ab79bd",
"/": "cf7640b37d2a82e13c99a4ed63ab79bd",
"main.dart.js": "5976b69ee8001dc293311b9455945bac",
"manifest.json": "baee4e215f8c3c7e784bac904e5c97d9",
"favicon.png": "e94487f2078aaf8fba3d043aef7910b0",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"assets/FontManifest.json": "b90c08596ce35820d3450960fe864d6f",
"assets/NOTICES": "7c103bbbc86915c93928750f033879e4",
"assets/fonts/RobotoMono.ttf": "9e06bf8e4155ad3a942a9ff38f59fbc4",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/images/callsign.png": "5cfe43da205372f6a36e5c4abf0f2e25",
"assets/assets/images/azimuth_map.png": "028c203de9fa22599626a91076528991",
"assets/assets/images/stats.png": "c8f3572ae8c986ad59c1a50edf519851",
"assets/assets/cil.txt": "5c491ab057c3cfe39e710d8a4cf58877",
"assets/assets/flags/64/BJ.png": "fe91ce93b49756de9fa4705aa6235866",
"assets/assets/flags/64/SY.png": "1ba8cccd3e58103758fab4596e1223c5",
"assets/assets/flags/64/UG.png": "abe1b3b190b63ba4d3f110158cf774a5",
"assets/assets/flags/64/MR.png": "dc40c463a375231bbc2dec98c18a51c5",
"assets/assets/flags/64/EC.png": "14cb45a95dc52fe3e02c2bf491c0d56a",
"assets/assets/flags/64/DO.png": "7fd4b536b8cc0bf0b8f4bcd25070ace2",
"assets/assets/flags/64/BN.png": "ed4fafeb4ded30df551131ec72a6be22",
"assets/assets/flags/64/CC.png": "be294d22813b92b5dbc70ab998c87c6e",
"assets/assets/flags/64/SD.png": "ae777c1f009a5ea14272fc82fbba6d60",
"assets/assets/flags/64/IR.png": "44afebaf40b466ee25d5f5032da55181",
"assets/assets/flags/64/CA.png": "405706bacf29d815287abee42b172e3c",
"assets/assets/flags/64/TD.png": "e6885f29b84bf8c770891ed5adfbb991",
"assets/assets/flags/64/GQ.png": "25881c2497fa35937ad1d20fb4bea2ab",
"assets/assets/flags/64/KH.png": "4ca65917397a8c28c5cfbdc48b6b2d65",
"assets/assets/flags/64/SS.png": "b8642839423bb2212306e845c6998d4d",
"assets/assets/flags/64/MO.png": "6080d2a689095a96217fa15b3ac59229",
"assets/assets/flags/64/TH.png": "a2fe627ca06215025ef285073f348953",
"assets/assets/flags/64/NC.png": "3e68c745a4354fd3141ee041e3d34107",
"assets/assets/flags/64/PG.png": "872f4187a373a4d3bd0795468f42a647",
"assets/assets/flags/64/VU.png": "7e5226ca06c84dcabfc47bd272b6d5e1",
"assets/assets/flags/64/SB.png": "1e1601b89dc808a4d9d0d39f250c6053",
"assets/assets/flags/64/BG.png": "7d8a75329389f1bcc53d9e89ac7122f7",
"assets/assets/flags/64/KR.png": "0f9d9d2797d5a0791e41cfc5e5784604",
"assets/assets/flags/64/MS.png": "1eb41eedc8beac082a18a0b6c7bd9fa9",
"assets/assets/flags/64/TN.png": "d17e346f5308a758aed5575725b0e41d",
"assets/assets/flags/64/SE.png": "d31040bd3ceda0c1d72b93671d1c416f",
"assets/assets/flags/64/KW.png": "c8bb7eb157cbb9f77079661b3dd4dfd6",
"assets/assets/flags/64/LV.png": "eeb19cda49c0c6c966fd40c4dac31ebd",
"assets/assets/flags/64/ML.png": "64a065ce23468e7c6a539816d4c41e89",
"assets/assets/flags/64/UY.png": "760565e8eeba0de31325306320958631",
"assets/assets/flags/64/ZM.png": "ce9f94dce5178537fb75535f3c21d5b8",
"assets/assets/flags/64/NL.png": "3592e391492f97ce3dfeeb939ebf096a",
"assets/assets/flags/64/MM.png": "62e6eb555241d225f7b0e2651f66d2aa",
"assets/assets/flags/64/GM.png": "97946c10f656584e0976b8f3421136e1",
"assets/assets/flags/64/IL.png": "45f505117486ae5d26c68ca81e75c4b0",
"assets/assets/flags/64/UZ.png": "5e270cd9f3c8597ed98be7bf093be6e8",
"assets/assets/flags/64/PY.png": "192282f252caed85ba65414b023b207b",
"assets/assets/flags/64/PR.png": "408ca35955949f0b5fd66cdd4465b364",
"assets/assets/flags/64/PA.png": "822f456209226a836f7d4459e453cdb5",
"assets/assets/flags/64/AT.png": "d135212d8089777bc78c2dfe51f918f8",
"assets/assets/flags/64/MV.png": "bdbbfe0093c8f867e873f11d5d51f28d",
"assets/assets/flags/64/AZ.png": "fdef7c4e950fec36d22c91560fa7ca67",
"assets/assets/flags/64/BA.png": "3bb806fae218f5fd70af5ae789986ecc",
"assets/assets/flags/64/MD.png": "8dad3126f1a6cb994bdb20e382c69501",
"assets/assets/flags/64/SR.png": "a975e5e879dd5394dbfceec510662eb8",
"assets/assets/flags/64/TO.png": "88b327cb2ed61c08bd3cecd3331bacbf",
"assets/assets/flags/64/AO.png": "618110c8f1f6be68edfa2f1852f73127",
"assets/assets/flags/64/PN.png": "7f946ea63f34a0dd7702346833089a53",
"assets/assets/flags/64/MN.png": "cfe7cb37e44109b13c2e45410fa93ad6",
"assets/assets/flags/64/KN.png": "5fee5c4a9031e69f24b5a6b1360aa1d8",
"assets/assets/flags/64/AX.png": "733f32bfb8a640b9b609b67c4162f8d0",
"assets/assets/flags/64/CO.png": "cc1b8e08fa4a57d4d0dda81b1977075b",
"assets/assets/flags/64/GG.png": "95e37f09e2a36cfa9de313125f09d0ad",
"assets/assets/flags/64/BQ1.png": "84f9adabe674c39e78064153ba5b345c",
"assets/assets/flags/64/FM.png": "4a32435bd8ab6ede66a076f7b62c74e5",
"assets/assets/flags/64/BW.png": "a1b54c0396321debf7dda4a3b3d7456d",
"assets/assets/flags/64/CV.png": "9c74c8d5ae3f8892cc01b738e46e86c4",
"assets/assets/flags/64/PL.png": "5b1373331d140272dca42fe9c4aa6b7d",
"assets/assets/flags/64/NA.png": "b47307ed4db484c3bd7432c902077d14",
"assets/assets/flags/64/VI.png": "0b74f3babf10251710a2354f58fb2008",
"assets/assets/flags/64/TK.png": "9c60790c068e476e25cfafee2e13f8f8",
"assets/assets/flags/64/VA.png": "da4b50cf47319c2bd62f7699206fd422",
"assets/assets/flags/64/GU.png": "acf1a713db3a34c74f0f0169d55e5b42",
"assets/assets/flags/64/TW.png": "d19d3146194be62664095c346f19dd4d",
"assets/assets/flags/64/ZA.png": "f9acce6e757e86bd3183ae9d0a372482",
"assets/assets/flags/64/CG.png": "97bf60facadd2a2288cf87835b7c3da8",
"assets/assets/flags/64/LS.png": "6e2af70417873408a694c26edcd65a5f",
"assets/assets/flags/64/SC.png": "c7af3d60cb826867b804206d63a1b85a",
"assets/assets/flags/64/BZ.png": "c4cbe6c823524f613046e5dad69ca927",
"assets/assets/flags/64/PF.png": "0adf11d1a3a33afa51e0836b33cc0785",
"assets/assets/flags/64/ID.png": "ae91994c67e2b53d310b62256ff6ad79",
"assets/assets/flags/64/QA.png": "ee9a647234200ac4ed8da53c87bd4925",
"assets/assets/flags/64/EG.png": "dcfc0791bc4189e495bd72ddc92331c4",
"assets/assets/flags/64/CY.png": "ffddd27cd7a4cffe4b2bfc84752e5ce5",
"assets/assets/flags/64/NP.png": "23506a637b5fb0d3c7493c49f3bb7c80",
"assets/assets/flags/64/RO.png": "d1ee698587470f71ea8c7cb2521485c5",
"assets/assets/flags/64/HR.png": "6cd90f0ec96e9eaa8dcd05a04b61f921",
"assets/assets/flags/64/AE.png": "aa07fe6771a0417b27f0ec65595ce504",
"assets/assets/flags/64/ZW.png": "65ec877241eeb2e5bd0dcf2e048b58af",
"assets/assets/flags/64/UA.png": "ffbb605c1ea8bb86d817d4a1f3073243",
"assets/assets/flags/64/HU.png": "a436a7a1a57be8cf9a3a9935885f6ada",
"assets/assets/flags/64/MU.png": "98869c7e3d9899321d9a274d1b2f2f1a",
"assets/assets/flags/64/BR.png": "8498dfed54abaf107b171eb8cead14ca",
"assets/assets/flags/64/NU.png": "2717fdb0a524ad679bf6f207f7dd6019",
"assets/assets/flags/64/FJ.png": "131e168d149e2c5c0bfc3b447e4c919c",
"assets/assets/flags/64/HN.png": "cd309fa460ada50df98a4342fc0e95b2",
"assets/assets/flags/64/CH.png": "c23c77ca1513f327065e8a28397c2b2c",
"assets/assets/flags/64/CM.png": "ca876cb747f23323725a133bd679d7d5",
"assets/assets/flags/64/HK.png": "e3c6adfe951220ee765e68b498daac6f",
"assets/assets/flags/64/KG.png": "677f46e725247ac9883d8a9e2d215ca3",
"assets/assets/flags/64/VE.png": "e1a44006ba1a8604507d9c6cd1dc15e6",
"assets/assets/flags/64/TT.png": "6fd22a117aa2e1c0d2d6ac258ea2c82d",
"assets/assets/flags/64/PK.png": "2f6ba4476d21d8d05b9be1054715c2af",
"assets/assets/flags/64/NG.png": "70f71f625c5152547d6a915634a7bbc3",
"assets/assets/flags/64/CI.png": "a6321dd0168f91cc3b5e7d10d9d304c0",
"assets/assets/flags/64/AS.png": "38e1cb6bfbdcc3e06cbe0a606f783f9a",
"assets/assets/flags/64/BE.png": "a1c7d055c2913f540185b4002cd08496",
"assets/assets/flags/64/AL.png": "ce8648406f00161529ae16ba5cdd2bf1",
"assets/assets/flags/64/SZ.png": "f8e2e6e8279c106993cac2e957cc9b74",
"assets/assets/flags/64/ZK.png": "a8ea7adcd8a20711d7399b9f1b4c3f4e",
"assets/assets/flags/64/TG.png": "4d325e7542f6b1e725c30401ede32c16",
"assets/assets/flags/64/SL.png": "7ea493e037b3c81e9d923e94c433b234",
"assets/assets/flags/64/LY.png": "1c6a465fb255e15239edce2735291640",
"assets/assets/flags/64/JM.png": "9a58bf7af6d7169ca9e918f5ff18e86b",
"assets/assets/flags/64/BY.png": "50086fd50b9fe0a830a23709f556c0c6",
"assets/assets/flags/64/IE.png": "3fdafac140f7969f59858efa1b87d3f7",
"assets/assets/flags/64/CN.png": "338eea6f11bbc636451f3ad04853688d",
"assets/assets/flags/64/GS.png": "6f4031a5483e8b46b314cdce533c21fd",
"assets/assets/flags/64/PS.png": "ac01fc784a6a1563e266a988d2152a40",
"assets/assets/flags/64/TR.png": "55542e179b69399640dae396e08bc02e",
"assets/assets/flags/64/GI.png": "480283a5875fe40981f550d0a0d7e1da",
"assets/assets/flags/64/LC.png": "d721dbace182c17ef3cd6670f4a88716",
"assets/assets/flags/64/BO.png": "1978704de47367d516ca22fed8a32824",
"assets/assets/flags/64/KI.png": "f129ed0e4fd13a83ec9205c502520c09",
"assets/assets/flags/64/KZ.png": "40b12ae5f51a4637c99da802d0f64974",
"assets/assets/flags/64/YE.png": "be3f86bf699fea66511233961be8b075",
"assets/assets/flags/64/SI.png": "985d066e4ed2ef648f71f3caf7bc457a",
"assets/assets/flags/64/AN.png": "77db470c04394eb59aa239bb39e3101d",
"assets/assets/flags/64/IM.png": "57d72625b393bb88e0107306100c6a2b",
"assets/assets/flags/64/X1.png": "ded594a124fc5b4514d48a9237970312",
"assets/assets/flags/64/US.png": "5566dea3b847d771b50094756904bc6a",
"assets/assets/flags/64/MQ.png": "9ff612007e92a5330ad737efdfd56e36",
"assets/assets/flags/64/FI.png": "7ffe0ba6def3fd7332e71e9c397c133b",
"assets/assets/flags/64/AG.png": "e0260023fe1715b96c51a5f735c4983d",
"assets/assets/flags/64/ST.png": "d41b3b1339663a5104d2530561c26b3c",
"assets/assets/flags/64/PZ.png": "caf544f0b6015332b7bd22fd35bf2aae",
"assets/assets/flags/64/SA.png": "ff73cbbfabeb045a5c4d00257ddb3d0e",
"assets/assets/flags/64/AI.png": "8a78722f1fb85d41fa1bf8dd8afbd1c6",
"assets/assets/flags/64/EE.png": "274afcfe938ea39a80c63f3eb3d6eb6b",
"assets/assets/flags/64/GA.png": "ceafe3233339acc9593aed74e2120711",
"assets/assets/flags/64/CU.png": "5a628cee507e6de1d2e170bc8a7d8982",
"assets/assets/flags/64/RS.png": "c58accb9dcdebcc8b229c707eb6ca5e9",
"assets/assets/flags/64/BH.png": "69f268a2c558ade3fc8c1e3598eb8df5",
"assets/assets/flags/64/ZP.png": "2d17c50e5f12f1a174abdbefdb6bc0e6",
"assets/assets/flags/64/CF.png": "6bb469f2c7e5b7602365a44c1cb9cc05",
"assets/assets/flags/64/BD.png": "868c84debaf17647cb601c81fc84f9c5",
"assets/assets/flags/64/MC.png": "ae91994c67e2b53d310b62256ff6ad79",
"assets/assets/flags/64/TV.png": "385b5a1e6a9e41ea73ae4c7fa0d2bbd7",
"assets/assets/flags/64/PH.png": "a2a1a5476bfd5528c23f1c1bad5dd79f",
"assets/assets/flags/64/YT.png": "8147a2aaefd3e2b3d2fba90e370b9849",
"assets/assets/flags/64/DK.png": "9458ab1e5684e4275f6bc2b0e0b73fd6",
"assets/assets/flags/64/CD.png": "6056398789e00abe30bd7f9ff943295f",
"assets/assets/flags/64/MH.png": "ba445af48d0ff1e0ed4719e092f4fee3",
"assets/assets/flags/64/ZC.png": "d475f52a87a85e5fae7a94588328a0ea",
"assets/assets/flags/64/RW.png": "9f28fd1b13c84d7533fd22331293f144",
"assets/assets/flags/64/DM.png": "db8b010115e2578ba965545ce30ca213",
"assets/assets/flags/64/VC.png": "6830d44ac94144290eb76e71c38a31a1",
"assets/assets/flags/64/GH.png": "6f8aabd1fc72a9fa872300116e506508",
"assets/assets/flags/64/NF.png": "4616ea934d60842fbd8f316b510eeeb1",
"assets/assets/flags/64/SN.png": "aafda67764b42735dd2cc44ad6c0b023",
"assets/assets/flags/64/LK.png": "70a60f1cc7c85154c1c643acc724295b",
"assets/assets/flags/64/NE.png": "4c78a2f1257cf8d57baee903d7c7d2cf",
"assets/assets/flags/64/FR.png": "ca7991644678ec0b18d0598952fd4e91",
"assets/assets/flags/64/GB.png": "440946f64cf582b15a5f58b9899aeff4",
"assets/assets/flags/64/MG.png": "79cfc77334a56d8c64220e42a5008b53",
"assets/assets/flags/64/PE.png": "d850c6a105978653c550fb8adc9e52f1",
"assets/assets/flags/64/MZ.png": "4af29df90e7721cd6c9cca98da8f8f8c",
"assets/assets/flags/64/OM.png": "d059efd21a9bc51cb32a6196cb5ac7c0",
"assets/assets/flags/64/BB.png": "3bd331d0d43035c90a78517f296c0fea",
"assets/assets/flags/64/BS.png": "d581da9e0960220fe2596166807cd349",
"assets/assets/flags/64/DZ.png": "b69ac815cd44893c43431ace62cb609a",
"assets/assets/flags/64/KY.png": "0ff6b4d81d669e26e2de4c7a2c3d4460",
"assets/assets/flags/64/ES.png": "1817004ca5ac952f74b3bdbe81b27326",
"assets/assets/flags/64/AF.png": "1ba18f5f53b474a83fc6a53a345ebdfc",
"assets/assets/flags/64/ME.png": "08df75414e51e8143264db337680c371",
"assets/assets/flags/64/CX.png": "8d669c908f4c296d5149cb7300958261",
"assets/assets/flags/64/WF.png": "15e8ac19b85237c52f06087920fd2dc5",
"assets/assets/flags/64/NI.png": "46f1f69881857731d71b52600fcafdfa",
"assets/assets/flags/64/EH.png": "b5145776a1ac0e7e16bb5021715873da",
"assets/assets/flags/64/LA.png": "3ed980a4143e4c067412b8170f1a1db8",
"assets/assets/flags/64/TC.png": "6a371163103290eda23d9c09b655a069",
"assets/assets/flags/64/TZ.png": "7284aee4c690ec04ddb70d940c9d4439",
"assets/assets/flags/64/JE.png": "3d35cb5f4de0d0cd42c18ffece3aff5c",
"assets/assets/flags/64/FK.png": "f5ebf86913909a59005c059febaf2490",
"assets/assets/flags/64/FO.png": "5a07337d67f245227265e14124b1c70e",
"assets/assets/flags/64/LT.png": "4ff3abd8ec54a0276ab579cd3ae0ec7c",
"assets/assets/flags/64/KP.png": "f26179250b6db137f5e34967d90a2b35",
"assets/assets/flags/64/GL.png": "4c84081309462ddb02561369bc4f28c1",
"assets/assets/flags/64/BF.png": "4b21b2239f59688673a98a927c4bfe5f",
"assets/assets/flags/64/VN.png": "69c6bba58c304ef21b88e47fb107d246",
"assets/assets/flags/64/TJ.png": "2e8732161797465def806f56ea2bb85d",
"assets/assets/flags/64/IN.png": "8c86c142d144ddfac334ddad141f1165",
"assets/assets/flags/64/PT.png": "cfa8301edccced36ab7b0f3be2d161b5",
"assets/assets/flags/64/SK.png": "cade7dcdd89102d1201701bf343e1aab",
"assets/assets/flags/64/IT.png": "a7cf4483a592dc33674a34c628babfc9",
"assets/assets/flags/64/DE.png": "ebc7060c1f826bd704328763899cbd3c",
"assets/assets/flags/64/SG.png": "9a51b087000ee2a487efbd0d5a6a0ed0",
"assets/assets/flags/64/CZ.png": "be5cd664057acb3dbe89db05acda2486",
"assets/assets/flags/64/AR.png": "5175c3df95e4972d1dccbbd655cf447b",
"assets/assets/flags/64/AW.png": "23d1d4c3739659eb6d55cdebcd725906",
"assets/assets/flags/64/GN.png": "3d27ef5a35ffab95609d9558eb1ccb79",
"assets/assets/flags/64/BT.png": "5eb481e6ff659f2e6985ce42e0c82e06",
"assets/assets/flags/64/SH.png": "bbe2168c98c2be6b4dc94a3d16d57021",
"assets/assets/flags/64/GW.png": "392dec65d956344bce155cf2362ac83a",
"assets/assets/flags/64/TM.png": "aac111c9e302c48366c5a19ab47c0f1e",
"assets/assets/flags/64/CW.png": "555c478b7d3bc91e489b6cbaebf23aa2",
"assets/assets/flags/64/BM.png": "2a75a9c1a0b13b73d020294976b9753a",
"assets/assets/flags/64/SO.png": "31c08e4e807bfa6817bafdfd2a4f9d6b",
"assets/assets/flags/64/HT.png": "130e4798880979410faec5fa7cc88497",
"assets/assets/flags/64/NO.png": "7ca73a245febb8943b37963504f69ab3",
"assets/assets/flags/64/DJ.png": "f25be2e35be54ca4d2aec05dc679c7dd",
"assets/assets/flags/64/GD.png": "5fa1233a1e041763e26ece75c1b4e484",
"assets/assets/flags/64/GY.png": "3a1e72b29fd3f21789c1b83aa9d421ab",
"assets/assets/flags/64/KM.png": "74fe73e52aa978f57b3ce1310637fbdb",
"assets/assets/flags/64/MT.png": "b0578333f3fe8c6f7728fbd191ce8a87",
"assets/assets/flags/64/MX.png": "4d426b7922b9f3661626a9fa657379b5",
"assets/assets/flags/64/WS.png": "0bcd4f49644e9021bc46f1e273aa20ac",
"assets/assets/flags/64/LR.png": "eb3cbc47607422b6c8fdd1cfada10752",
"assets/assets/flags/64/MY.png": "cc5a25ac4cc67d22891eb2aaaf026b9c",
"assets/assets/flags/64/LU.png": "ad8924340bfdf95b2ecb7a604c4ae8ec",
"assets/assets/flags/64/SX.png": "600aaa4916d473802d079574f58522b7",
"assets/assets/flags/64/CR.png": "95e2f54e0c554f77e0d3db056148dfbe",
"assets/assets/flags/64/AM.png": "66cfe159aaed7858a6e7993f8ffcc775",
"assets/assets/flags/64/IS.png": "8f7995e89922b3f338b898afffdea444",
"assets/assets/flags/64/KE.png": "fa5d9df29729eec134e363d9253ed804",
"assets/assets/flags/64/NR.png": "577b54acac4698ba8ef5fdfa35a8a88f",
"assets/assets/flags/64/IQ.png": "6c7f3399864aeb2c9969ba467f24f335",
"assets/assets/flags/64/MW.png": "2be76b310b3fff654bd256c2cb8ba791",
"assets/assets/flags/64/MA.png": "9426102d8d67c409ee38b10b1cee55fb",
"assets/assets/flags/64/NZ.png": "f127067e815e68fffe41e1c68bfe19ce",
"assets/assets/flags/64/ET.png": "0ff226c1e86010b4ce26ea780fbc4099",
"assets/assets/flags/64/PW.png": "19ebbe211009fb3b038fe8f6ea0a6b64",
"assets/assets/flags/64/BI.png": "484b35fe497f0d7beb76798138510a68",
"assets/assets/flags/64/LI.png": "a1c05a274918a3311aa59d35b42e1a58",
"assets/assets/flags/64/LB.png": "a8450b0d4a8e5bef15bfa2e33b7d2d5e",
"assets/assets/flags/64/GE.png": "2d5c4b47dc2fb334d7ab19b44534b019",
"assets/assets/flags/64/JP.png": "7bfeb753e048fea1311f343647d1257b",
"assets/assets/flags/64/UN.png": "2523b2c52fae5cb8d8def31e6869c370",
"assets/assets/flags/64/VG.png": "1c4c7c3d5c0cbb6cc04ef42419e61b92",
"assets/assets/flags/64/GT.png": "1c5067ca9306584a5a9e5b4c09a7b26a",
"assets/assets/flags/64/X2.png": "44b40be64cb0893afbf6d88d71777505",
"assets/assets/flags/64/ER.png": "7d34dbe28a02a3c703a77a6369f8d745",
"assets/assets/flags/64/JO.png": "9ef719e1d24a6a16e8954f35c40a4e93",
"assets/assets/flags/64/RU.png": "695990a8e997087294638e1a43233c73",
"assets/assets/flags/64/GR.png": "b791a43c36382aae0fbb0dfcf35a276c",
"assets/assets/flags/64/CL.png": "396cdd76217ecb2f5efd2aedc087af22",
"assets/assets/flags/64/SV.png": "cd6237998a3a1d108add71177e84006b",
"assets/assets/flags/64/TL.png": "2233ff255cbf05a8b5a52f99e4ab4024",
"assets/assets/flags/64/AU.png": "5239254fe509bede00ac77ec15c93646",
"assets/assets/flags/64/SM.png": "7198c8dabb8a4b40fd724899ecd5520e",
"assets/assets/flags/64/MP.png": "c15790dc1fa67c21b89b8047e6d490b9",
"assets/assets/flags/64/AD.png": "343644075f924b53295e9e0741070af1",
"assets/assets/flags/64/MK.png": "c72219bff4545cda9b4f794e01abc73d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/AssetManifest.json": "acec67cbe09d18aca0b789aed9ff9e01",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"version.json": "264986322a48b7922b25b2e4442f259d",
"CNAME": "5d10c08e1962ddbb31e8517257f380ff"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
