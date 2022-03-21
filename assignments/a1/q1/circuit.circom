pragma circom 2.0.0;

//7457672556014162487472065518158328090252704233415054189820328174772177160972
//https://media.discordapp.net/attachments/944923724497428490/949449991481597972/Screen_Shot_2022-03-04_at_3.34.30_PM.png

include "mimcsponge.circom";

template merkle_root() {  
    signal input hash[2]; 
    signal output root;

    component memory_components = MiMCSponge(2, 220, 1);
    memory_components.ins[0] <== hash[0];
    memory_components.ins[1] <== hash[1];
    memory_components.k <== 0;
    root <== memory_components.outs[0];
}

template merkle_tree(n) {
    signal input leaves[n];
    signal output root;
    var hashed[2*n - 1];
    component memory_components[n];

    // convert leaves to hashed leaves
    for (var i = 0; i < n; i++) {
        memory_components[i] = MiMCSponge(1, 220, 1);
        memory_components[i].k <== 0;
        memory_components[i].ins[0] <== leaves[i];
        hashed[i] = memory_components[i].outs[0];
    }

    component h[2*n - 1];
    for(var i = 2; i < 2*n - 1; i=i+2){
        h[i] = merkle_root();
        h[i].hash[0] <== hashed[i-1];
        h[i].hash[1] <== hashed[i-2];
        hashed[i/2+n-1] = h[i].root;
    } 
    root <== hashed[2*n-2];
}

component main {public [leaves]} = merkle_tree(8);