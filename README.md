# bench int parsing

| Name                  |   Time/Run | mWd/Run | Percentage
|-----------------------|------------|---------|------------
| Stdint uint64 ts      |   635.36ns | 122.00w |     54.10%
| optimized ts          |   128.04ns |  21.00w |     10.90%
| Stdint uint64 small   |   113.10ns |  41.00w |      9.63%
| optimized small       |    60.82ns |  12.00w |      5.18%
| Stdint uint64 big     | 1_174.39ns | 212.00w |    100.00%
| optimized big         |   193.77ns |  33.00w |     16.50%
| Stdint uint64 hex     |   159.21ns |  50.00w |     13.56%
| optimized hex         |    75.31ns |  15.00w |      6.41%
| Stdint uint64 big_hex |   934.28ns | 176.00w |     79.55%
| optimized big_hex     |   160.98ns |  27.00w |     13.71%
| optimized_c big       |    22.67ns |   3.00w |      1.93%
| optimized_c ts        |    15.69ns |   3.00w |      1.34%
| optimized_c big_hex   |    18.62ns |   3.00w |      1.59%
