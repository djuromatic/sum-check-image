pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template Sum() {
    signal input a;
    signal input b;
    signal output c;
    c <== a + b;
 }


template CheckSum (N) {
    signal input a[N];
    signal input b;
    signal output c;

    var sum = 0x0;

    component sumField[N];
    component hash;
    // component hash[N][M];
    for(var i = 0; i < N; i+= 2 ) {
            assert(a[i] >= 0 && a[i] <= 255);
            assert(a[i + 1] >= 0 && a[i + 1] <= 255);
            sumField[i] = Sum();
            sumField[i].a <== a[i];
            sumField[i].b <== a[i + 1];

           // hash[i][j] = Poseidon(2);
           // hash[i][j].inputs[0] <== sumField[i][j].c;
           // hash[i][j].inputs[1] <== b;
           // sum += hash[i][j].out;

            sum += sumField[i].c;
    }

    hash = Poseidon(2);
    hash.inputs[0] <== sum;
    hash.inputs[1] <== b;

    c <== hash.out;

    log("hash", c);
}

component main = CheckSum(3840);

/* INPUT = {
    "a": [["0","1","0","0","1","1","0","1"], ["1","0","1","1","0","0","1","1"], ["1","0","1","1","0","0","1","1"], ["1","0","1","1","0","0","1","1"]],
    "b": "0x2F"
} */

