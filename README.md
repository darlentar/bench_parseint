# bench int parsing

| Name                                    | Time/Run | mWd/Run | Percentage |
|-----------------------------------------|----------|---------|------------|
| Stdint uint32                           | 600.95ns | 122.00w |    100.00% |
| Stdint uint64                           | 569.97ns | 122.00w |     94.85% |
| standard int                            |  25.39ns |         |      4.23% |
| naive imp                               |  23.12ns |   7.00w |      3.85% |
| naive imp int64                         | 498.54ns | 127.00w |     82.96% |
| naive imp int64 with hash_tabl          | 395.30ns |  67.00w |     65.78% |
| naive imp int64 with match              | 410.57ns |  97.00w |     68.32% |
| naive imp int64 with match v2           | 373.48ns |  97.00w |     62.15% |
| naive imp int64 with match v2 with loop | 376.56ns |  90.00w |     62.66% |
