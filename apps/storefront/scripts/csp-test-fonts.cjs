// Next's supported test hook: no Google/font provider requests in CSP verification.
module.exports = new Proxy({}, { get: () => "@font-face { font-family: 'CSP Test'; src: local('Arial'); font-style: normal; font-weight: 100 900; font-display: swap; }" });
