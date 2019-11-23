#include <bits/stdc++.h>

using namespace std;

void printFloat(float f) {
    union {
        float f;
        uint32_t i;
    } tmp{};
    tmp.f = f;
    string ans;
    for (int j = 0; j < 32; ++j) {
        if (j == 31 || j == 23) ans+= "_";
        ans += "01"[tmp.i & 1];
        tmp.i >>= 1;
    }
    reverse(ans.begin(), ans.end());
    cout << ans;
}

void PrintCase(float a, float b) {
    float s = a + b;
    printFloat(a);
    cout << "___";
    printFloat(b);
    cout << "___";
    printFloat(s);
    //cout << " //" << a << " + " << b << " = " << a + b;
    cout << endl;
}

int main() {

    freopen("D:\\testvector.tv","wt",stdout);

    PrintCase(0.5, 0.25);
    PrintCase(0.4453125, 0.4140625);
    PrintCase(0.46875, 0.4375);
    PrintCase(96, 384);
    cout << endl;

    PrintCase(-0.5, -0.25);
    PrintCase(-0.4453125, -0.4140625);
    PrintCase(-0.46875, -0.4375);
    PrintCase(-96, -384);
    cout << endl;

    PrintCase(-0.5, 0.25);
    PrintCase(-0.4453125, 0.4140625);
    PrintCase(-0.46875, 0.4375);
    PrintCase(-96, 384);
    cout << endl;

    PrintCase(0.5, -0.25);
    PrintCase(0.4453125, -0.4140625);
    PrintCase(0.46875, -0.4375);
    PrintCase(96, -384);
    cout << endl;

    PrintCase(0.4453125, 0);
    PrintCase(0, -0.4140625);
    PrintCase(-96, 0);
    PrintCase(96, 0);
    PrintCase(12345, -12345);
    PrintCase(0, 0);
    cout << endl;

    PrintCase(32149, -174667);
    PrintCase(575489, -231324);
    cout << endl;

    PrintCase(infinityf(), 0);
    PrintCase(infinityf(), 7);
    PrintCase(infinityf(), -9.25);
    cout << endl;

    PrintCase(-infinityf(), 0);
    PrintCase(-infinityf(), 7);
    PrintCase(-infinityf(), -9.25);
    cout << endl;

    PrintCase(-infinityf(), -infinityf());
    PrintCase(-infinityf(), +infinityf());
    PrintCase(+infinityf(), -infinityf());
    PrintCase(+infinityf(), +infinityf());
    cout << endl;

    float nan = infinityf()-infinityf();
    PrintCase(nan, +infinityf());
    PrintCase(nan, -infinityf());
    PrintCase(nan, 125);
    PrintCase(nan, 0);
    PrintCase(nan, -5.125);
    PrintCase(nan, nan);
    cout << endl;
}
