pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";

template GrayScale() {
    signal input red;
    signal input blue;
    signal input green;
    signal output grayscale;

    var RED = 299;
    var GREEN = 587;
    var BLUE = 114;
    var FACTOR = 1000;
    
    signal wr <== RED*red;
    signal wg <== GREEN*green;
    signal wb <== BLUE*blue;
    signal wsum <== wr + wg + wb;
    
    grayscale <== wsum/FACTOR;
  }

template CheckSum (N) {
    signal input a[N];
    signal input b;
    signal output c;

    var sum = 0x0;

    component grayScale[N];
    component hash;
    for(var i = 0; i < N; i+= 3 ) {
            assert(a[i] >= 0 && a[i] <= 255);
            assert(a[i + 1] >= 0 && a[i + 1] <= 255);
            assert(a[i + 2] >= 0 && a[i + 2] <= 255);
            grayScale[i] = GrayScale();
            grayScale[i].red <== a[i];
            grayScale[i].blue <== a[i+1];
            grayScale[i].green <== a[i+2];
            sum += grayScale[i].grayscale;
    }

    hash = Poseidon(2);
    hash.inputs[0] <== sum;
    hash.inputs[1] <== b;

    c <== hash.out;
}

component main = CheckSum(6144);

