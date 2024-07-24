pragma circom 2.0.0;

include "circomlib/circuits/poseidon.circom";


template switchPosition() {
    signal input in[2];
    signal input s;
    signal output out[2];

    s * (1 - s) === 0;
    out[0] <== (in[1] - in[0])*s + in[0];
    out[1] <== (in[0] - in[1])*s + in[1];
}

template privateKeyHasher() {
    signal input privateKey;
    signal output publicKey;
    component poseidonComponent;
    poseidonComponent = Poseidon(1);
    poseidonComponent.inputs[0] <== privateKey;
    publicKey <== poseidonComponent.out;
}

template nullifierHasher() {
    signal input root;
    signal input privateKey;
    signal input proposalId;
    signal output nullifier;
    component poseidonComponent;
    poseidonComponent = Poseidon(3);
    poseidonComponent.inputs[0] <== root;
    poseidonComponent.inputs[1] <== privateKey;
    poseidonComponent.inputs[2] <== proposalId;
    nullifier <== poseidonComponent.out;
}

template proveVote(levels) {
    signal input privateKey;
    signal input root;
    signal input proposalId;
    signal input vote;
    signal input pathElements[levels];
    signal input pathIndices[levels];
    signal output nullifier;

    signal leaf;
    component hasherComponent;
    hasherComponent = privateKeyHasher();
    hasherComponent.privateKey <== privateKey;
    leaf <== hasherComponent.publicKey;

    component selectors[levels];
    component hashers[levels];

    signal computedPath[levels];

    for (var i = 0; i < levels; i++) {
        selectors[i] = switchPosition();
        selectors[i].in[0] <== i == 0 ? leaf : computedPath[i - 1];
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        hashers[i] = Poseidon(2);
        hashers[i].inputs[0] <== selectors[i].out[0];
        hashers[i].inputs[1] <== selectors[i].out[1];
        computedPath[i] <== hashers[i].out;
    }
    root === computedPath[levels - 1];

    component nullifierComponent;
    nullifierComponent = nullifierHasher();
    nullifierComponent.root <== root;
    nullifierComponent.privateKey <== privateKey;
    nullifierComponent.proposalId <== proposalId;
    nullifier <== nullifierComponent.nullifier;
}

component main {public [root, proposalId, vote]} = proveVote(2);