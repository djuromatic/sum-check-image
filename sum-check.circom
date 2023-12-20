pragma circom 2.1.6;

include "circomlib/poseidon.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template Multiplier2() {
    signal input a;
    signal input b;
    signal output c;
    c <== a*b;
 }


template Example (N, M) {
    signal input a[N][M];
    signal input b;
    signal output c;

    var sum = 0;

    component firstField[N][M];
    component hash[N][M];
    for(var i = 0; i < N; i++) {
        for (var j = 0; j < M; j+=2){
            firstField[i][j] = Multiplier2();
            firstField[i][j].a <== a[i][j];
            firstField[i][j].b <== a[i][j+1];

            sum += firstField[i][j].c;
        } 
    }

    c <== sum * b;

    log("hash", c);
}

component main = Example(4, 8);

/* INPUT = {
    "a": [["0","1","0","0","1","1","0","1"], ["1","0","1","1","0","0","1","1"], ["1","0","1","1","0","0","1","1"], ["1","0","1","1","0","0","1","1"]],
    "b": 400
} */
