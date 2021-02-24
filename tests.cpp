#include "gtest/gtest.h"

extern "C" int64_t Sum(int32_t x, uint8_t y);
extern "C" bool CheckOverflow(int64_t x, int64_t y);
extern "C" int64_t ComputeFn(int64_t x, int64_t y);
extern "C" int64_t Clock(int32_t h, int32_t m, int32_t f);
extern "C" uint64_t Polynom(int32_t x);


TEST(Sum, Simple) {
  {
    EXPECT_EQ(Sum(0, 0), 0);
    EXPECT_EQ(Sum(INT32_MAX, 0), INT32_MAX);
    EXPECT_EQ(Sum(INT32_MIN, 0), INT32_MIN);
    EXPECT_EQ(Sum(-2384, 0), -2384);
  }
  {
    EXPECT_EQ(Sum(0, 0), 0);
    EXPECT_EQ(Sum(0, 255), 255);
    EXPECT_EQ(Sum(0, 4), 4);
    EXPECT_EQ(Sum(0, 234), 234);
  }
  {
    EXPECT_EQ(Sum(INT32_MAX, 255), 2147483902);
  }
}

TEST(CheckOverflow, Simple) {
  {
    EXPECT_FALSE(CheckOverflow(1, 1));
    EXPECT_FALSE(CheckOverflow(-7, 5));
    EXPECT_FALSE(CheckOverflow(0, 4));
  }
  {
    EXPECT_TRUE(CheckOverflow(127346182, 197346813));
    EXPECT_TRUE(CheckOverflow(27845689624, 0));
    EXPECT_TRUE(CheckOverflow(0, -92327356121));
  }
}

TEST(ComputeFn, Simple) {
  {
    EXPECT_EQ(ComputeFn(1, 0), 12);
    EXPECT_EQ(ComputeFn(-1, 0), -12);
    EXPECT_EQ(ComputeFn(-1, -1), -18);
    EXPECT_EQ(ComputeFn(0, 2), 54);
  }
}

TEST(Clock, Simple) {
  {
    EXPECT_EQ(Clock(0, 0, 330), 3600);
    EXPECT_EQ(Clock(1, 1, 341), 60);
    EXPECT_EQ(Clock(0, 0, 0), 0);
    EXPECT_EQ(Clock(3, 16, 358), 0);
    EXPECT_EQ(Clock(6, 30, 345), 0);
  }
  {
    EXPECT_EQ(Clock(4, 6, 347), 807);
    EXPECT_EQ(Clock(6, 23, 221), 2994);
    EXPECT_EQ(Clock(12, 50, 25), 1200);
  }
}

TEST(Polynom, Simple) {
  {
    EXPECT_EQ(Polynom(0), 6);
    EXPECT_EQ(Polynom(23), 525188);
    EXPECT_EQ(Polynom(42), 6007980);
    EXPECT_EQ(Polynom(100), 197039506);
  }
  {
    EXPECT_EQ(Polynom(INT32_MAX), 4611685954002878484);
    EXPECT_EQ(Polynom(INT32_MIN), 10737418246);
    EXPECT_EQ(Polynom(1024), 2195806219270);
  }
}



// ---------------------------------------------------------
