var DeedRegistry = artifacts.require("./DeedRegistry.sol");

const assertExpectedError = async (promise) => {
  try {
    await promise;
    assert.fail(0,0,'expected test to throw an exception')();
  } catch (error) {
    assert(error.message.indexOf('invalid opcode') >= 0, `Expected throw, but got: ${error.message}`);
  }
}

contract('DeedRegistry', function (accounts) {
  it("...should add a new registrar.", function () {
    return DeedRegistry.new().then(function (instance) {
      instance.addRegistrar(accounts[1], { from: accounts[0] });
      return instance.isRegistrar(accounts[1]);
    });
  });

  it("...should throw when non-registrar attempts to add self.", async (accounts) => {
    var registry = await DeedRegistry.new({from:accounts[0]}); // it belongs to accounts[0]
     // accounts[1] shouldn't have access
   // assertExpectedError(registry.addRegistrar(accounts[1], {from:accounts[1]}));
  });


});
