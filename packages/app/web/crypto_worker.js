importScripts("nacl-fast.min.js");

onmessage = function(e) {
  const messge = e.data[0];
  if (messge === 0) {
    newKeyPair(e.data[1]);
  }
}

const newKeyPair = function(seed) {
  try {
    const seedArr = Uint8Array.from(hexToBytes(seed));
    const keyPair = nacl.sign.keyPair.fromSeed(seedArr);
    const publicKey = bytesToHex(keyPair.publicKey,);
    const privateKey = bytesToHex(keyPair.secretKey);
    const data = {
      status: 'success',
      data: {
        publicKey,
        privateKey
      }
    }
    postMessage(data);
  } catch (error) {
    postMessage({
      status: 'failed',
      message: `failed to generate key pair:${error}`
    });
  }
}

const bytesToHex = bytes => {
  const hex = [];

  for (let i = 0; i < bytes.length; i++) {
    hex.push((bytes[i] >>> 4).toString(16));
    hex.push((bytes[i] & 0xf).toString(16));
  }
  return `${hex.join('')}`;
};

const hexToBytes = hex => {
  hex = hex.toString(16);
  hex = hex.replace(/^0x/i, '');
  hex = hex.length % 2 ? `0${hex}` : hex;

  const bytes = [];
  for (let c = 0; c < hex.length; c += 2) {
    bytes.push(parseInt(hex.substr(c, 2), 16));
  }
  return bytes;
};
