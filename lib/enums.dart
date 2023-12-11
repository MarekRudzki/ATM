enum Denominations {
  bill500(500),
  bill200(200),
  bill100(100),
  bill50(50),
  bill20(20),
  bill10(10);

  const Denominations(this.denomination);

  final int denomination;
}
