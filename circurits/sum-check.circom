pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template Multiplier2() {
    signal input a;
    signal input b;
    signal output c;
    c <== a + b;
 }


template Example (N, M) {
    signal input a[N][M];
    signal input b;
    signal output c;

    var sum = 0x0;

    component sumField[N][M];
    component hash[N][M];
    for(var i = 0; i < N; i++) {
        for (var j = 0; j < M; j+=2){
            sumField[i][j] = Multiplier2();
            sumField[i][j].a <== a[i][j];
            sumField[i][j].b <== a[i][j+1];

            hash[i][j] = Poseidon(2);
            hash[i][j].inputs[0] <== sumField[i][j].c;
            hash[i][j].inputs[1] <== b;



            sum += hash[i][j].out;
        } 
    }

    c <== sum;

    log("hash", c);
}

component main = Example(4, 8);

/* INPUT = {
    "a": [["0","1","0","0","1","1","0","1"], ["1","0","1","1","0","0","1","1"], ["1","0","1","1","0","0","1","1"], ["1","0","1","1","0","0","1","1"]],
    "b": "0x2F"
} */
