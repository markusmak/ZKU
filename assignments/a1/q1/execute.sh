source ~/.cargo/env    

circom circuit.circom --r1cs --wasm --sym --c

cd circuit_js

node generate_witness.js

node circuit_js/generate_witness.js circuit_js/circuit.wasm input.json witness.wtns

snarkjs wtns export json witness.wtns witness.json

wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_15.ptau

snarkjs plonk setup circuit.r1cs powersOfTau28_hez_final_15.ptau circuit.zkey

snarkjs zkey export verificationkey circuit.zkey verification_key.json

snarkjs plonk prove circuit.zkey witness.wtns proof.json public.json

snarkjs plonk verify verification_key.json public.json proof.json















