// test/Badge.test.js
// Load dependencies
const { expect } = require('chai');

// Import utilities from Test Helpers
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');

// Load compiled artifacts
const BadgeFactory = artifacts.require('BadgeFactory');

// Start test block
contract('BadgeFactory', function () {
  beforeEach(async function () {
    // Deploy a new Badge contract for each test
    this.factory = await BadgeFactory.new();
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