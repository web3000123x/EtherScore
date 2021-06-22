// test/Badge.test.js
// Load dependencies
const { expect } = require('chai');

// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

// Load compiled artifacts
const Badge = artifacts.require('Badge');

// Start test block
contract('Badge', function () {
  beforeEach(async function () {
    // Deploy a new Badge contract for each test
    this.badge = await Badge.new();
  });

  // Test case
  it('retrieve returns a value previously stored', async function () {
    // Store a value
    //await this.box.store(42);

    // Test if the returned value is the same one
    // Note that we need to use strings to compare the 256 bit integers
    //expect((await this.box.retrieve()).toString()).to.equal('42');
  });
});