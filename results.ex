round_robin = [best_case: %{
  count: 56537,
  execution_time: 233814,
  metrics: %{
    "worker@worker-1": %{
      chunk_sizes: [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000,
       1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000,
       1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
      execution_times: [6268, 7114, 6400, 7973, 7880, 4380, 6429, 7782, 6483,
       7342, 6293, 7611, 8602, 5490, 6745, 7036, 6854, 7262, 6377, 8577, 3907,
       6778, 6744, 6762, 6792, 7459, 8081, 5292, 7464, 7048, 7021, 6910, 7390,
       7010],
      total_blocks: 34
    },
    "worker@worker-2": %{
      chunk_sizes: [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000,
       1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000,
       1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
      execution_times: [6047, 7338, 5920, 7556, 8558, 5786, 6290, 6639, 6621,
       7413, 6201, 8359, 3955, 7017, 6409, 6787, 6509, 7637, 7781, 4703, 6764,
       6918, 6704, 7056, 6753, 6979, 8407, 4567, 7169, 6392, 7030, 6804, 6726],
      total_blocks: 33
    },
    "worker@worker-3": %{
      chunk_sizes: [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000,
       1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000,
       1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
      execution_times: [6823, 6530, 7787, 5915, 8503, 4019, 7396, 6247, 6754,
       6314, 7743, 7768, 4593, 6433, 7204, 6569, 7210, 6585, 7410, 8427, 4980,
       7085, 6647, 6869, 7046, 6277, 8460, 3954, 6588, 6918, 6505, 7098, 6962],
      total_blocks: 33
    }
  }
},
median_case_1: %{
  count: 47277,
  execution_time: 494518,
  metrics: %{
    "worker@worker-1": %{
      chunk_sizes: [3, 6, 9, 15, 22, 32, 45, 63, 87, 121, 168, 232, 319, 439,
       604, 830, 1141, 1566, 2151, 2952, 4050, 2, 5, 8, 13, 19, 28, 40, 56, 78,
       108, 151, 208, 287, 395, 543, 747, 1026, 1409, 1935, 2656, 3645, 5000],
      execution_times: [0, 1, 2, 7, 10, 9, 19, 31, 90, 166, 256, 437, 959, 1445,
       2953, 5090, 8056, 11709, 25770, 42508, 44472, 0, 0, 0, 2, 4, 13, 16, 30,
       38, 93, 238, 479, 549, 1674, 2274, 4971, 4126, 12395, 20454, 36419,
       53164, 99267],
      total_blocks: 43
    },
    "worker@worker-2": %{
      chunk_sizes: [2, 5, 8, 13, 19, 28, 40, 56, 78, 108, 151, 208, 287, 395,
       543, 747, 1026, 1409, 1935, 2656, 3645, 5000, 4, 7, 11, 17, 25, 36, 50,
       70, 97, 135, 187, 258, 355, 488, 672, 923, 1268, 1741, 2390, 3280, 4500],
      execution_times: [0, 1, 1, 3, 5, 6, 17, 26, 62, 117, 275, 404, 636, 1391,
       2685, 4634, 7829, 14795, 21860, 36248, 63363, 101270, 0, 1, 3, 3, 7, 12,
       21, 44, 60, 194, 535, 514, 1291, 1607, 4137, 7295, 10714, 16803, 31146,
       39747, 85353],
      total_blocks: 43
    },
    "worker@worker-3": %{
      chunk_sizes: [544, 4, 7, 11, 17, 25, 36, 50, 70, 97, 135, 187, 258, 355,
       488, 672, 923, 1268, 1741, 2390, 3280, 4500, 3, 6, 9, 15, 22, 32, 45, 63,
       87, 121, 168, 232, 319, 439, 604, 830, 1141, 1566, 2151, 2952, 4050],
      execution_times: [2457, 0, 1, 1, 6, 10, 23, 26, 38, 93, 293, 309, 449,
       1303, 1709, 2902, 5506, 11827, 9516, 30976, 52175, 84086, 0, 0, 2, 3, 8,
       13, 15, 35, 76, 107, 399, 548, 604, 1575, 3248, 6686, 4813, 14198, 26511,
       44535, ...],
      total_blocks: 43
    }
  }
},
median_case_2: %{
  count: 38872,
  execution_time: 1793781,
  metrics: %{
    "worker@worker-1": %{
      chunk_sizes: [3, 6, 9, 14, 20, 29, 42, 59, 83, 116, 160, 221, 305, 419,
       576, 793, 1090, 1497, 2055, 2820, 3871, 5313, 7290, 10000],
      execution_times: [1, 0, 1, 3, 4, 12, 20, 21, 50, 134, 363, 425, 612, 1528,
       3030, 5595, 6856, 15749, 23790, 40634, 50858, 107639, 504146, 1030993],
      total_blocks: 24
    },
    "worker@worker-2": %{
      chunk_sizes: [2, 5, 8, 12, 18, 26, 37, 53, 74, 104, 144, 198, 274, 377,
       518, 713, 981, 1347, 1849, 2538, 3483, 4781, 6561, 9000],
      execution_times: [0, 1, 1, 2, 7, 21, 31, 40, 49, 101, 285, 377, 493, 1438,
       2013, 3044, 7566, 13481, 16155, 34185, 57842, 93351, 279973, 605021],
      total_blocks: 24
    },
    "worker@worker-3": %{
      chunk_sizes: [326, 4, 7, 10, 16, 23, 33, 47, 66, 93, 129, 178, 246, 339,
       466, 641, 882, 1212, 1664, 2284, 3134, 4302, 5904, 8100],
      execution_times: [1002, 0, 0, 1, 4, 5, 12, 24, 48, 61, 152, 335, 588,
       1106, 1506, 3045, 4825, 10825, 9108, 27956, 48398, 73094, 135593,
       590343],
      total_blocks: 24
    }
  }
},
worst_case: %{
  count: 35485,
  execution_time: 4968997,
  metrics: %{
    "worker@worker-1": %{
      chunk_sizes: [4, 39, 312, 2500, 2, 19, 156, 1250, 10000, 9, 78, 625, 5000,
       4, 39, 312, 2500, 2, 19, 156, 1250, 10000],
      execution_times: [0, 35, 780, 34216, 1, 4, 213, 10378, 707811, 2, 65,
       2519, 101555, 1, 17, 569, 33818, 0, 4, 313, 5895, 1286145],
      total_blocks: 22
    },
    "worker@worker-2": %{
      chunk_sizes: [2, 19, 156, 1250, 10000, 9, 78, 625, 5000, 4, 39, 312, 2500,
       2, 19, 156, 1250, 10000, 9, 78, 625, 5000],
      execution_times: [0, 6, 217, 10905, 1041845, 3, 84, 2295, 105123, 0, 24,
       691, 33242, 0, 5, 170, 9858, 951247, 2, 70, 3741, 98012],
      total_blocks: 22
    },
    "worker@worker-3": %{
      chunk_sizes: [30, 9, 78, 625, 5000, 4, 39, 312, 2500, 2, 19, 156, 1250,
       10000, 9, 78, 625, 5000, 4, 39, 312, 2500],
      execution_times: [21, 3, 101, 2145, 103053, 1, 11, 740, 36487, 0, 6, 250,
       11072, 931212, 2, 53, 1810, 99883, 0, 20, 1156, 23851],
      total_blocks: 22
    }
  }
}
]
