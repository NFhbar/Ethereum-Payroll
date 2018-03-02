const Payroll = artifacts.require('Payroll');
import assertRevert from 'zeppelin-solidity/test/helpers/assertRevert';
import expectThrow from './helpers/expectThrow';

contract ('Payroll', accounts => {

  let payroll;
  const owner = accounts[0];
  const employeeA = accounts[1];
  const employeeB = accounts[2];
  const decimals = 18;
  const initialSupply = 10000 * (10 ** (decimals));

  beforeEach(async () => {
    payroll = await Payroll.new();
  });

  it("Should have no employess on creation", async () => {
    const numberEmployees = await payroll.getEmployeeCount();
    assert.equal(numberEmployees,0);
  });

  it("Owner should have total initial supply", async () => {
    const _initialSupply = await payroll.getTotalSupply();
    assert.equal(_initialSupply, initialSupply);
  });

  it("Should not allow non-owner to add employee", async () => {
    try {
      await payroll.addEmployee(employeeA, 10, 10,{from:employeeA});
      assert.fail("Non owner cannot add employee");
    } catch (error) {
      assert(error);
    }
  });

  it("Should not allow non-employee to get paid", async () => {
    try {
      await payroll.addEmployee(employeeA, 10, 1);
      await payroll.getPay(1,{from:employeeB});
      assert.fail("Non employee cannot get paid");
    } catch (error) {
      assert(error);
    }
  });

  it("Should add employee correctly", async () => {
    await payroll.addEmployee(employeeA, 10, 10);
    assert.equal(await payroll.getEmployeeCount(),1);
    assert.equal(await payroll.getEmployeeID(employeeA),1);
    assert.equal(await payroll.getEmployeeAddress(1),employeeA);
    assert.equal(await payroll.getEmployeeSalary(employeeA),10);
    assert.equal(await payroll.getEmployeePayday(employeeA),10);
    assert.equal(await payroll.getEmployeeBalance(1),0);
  });

  it("Should not add employee twice", async () => {
    await payroll.addEmployee(employeeA, 10, 10);
    try {
      await payroll.addEmployee(employeeA, 10, 10);
    } catch (error) {
      assert(error);
    }
  });

  it("Should pay employee for correct pay period", async () => {
    await payroll.addEmployee(employeeA, 10, 1);
    await payroll.getPay(1,{from:employeeA});
    assert.equal(await payroll.getEmployeeBalance(1),10);
  });

  it("Should change pay period after paying employee", async () => {
    await payroll.addEmployee(employeeA, 10, 1);
    await payroll.getPay(1,{from:employeeA});
    assert.equal(await payroll.getEmployeePayday(employeeA),2);
  });

  it("Should not pay employee for incorrect pay period", async () =>{
    try {
      await payroll.addEmployee(employeeA, 10, 1);
      await payroll.getPay(2,{from:employeeA});
    } catch (error) {
      assert(error);
    }
  });

  it("Should be able to change employee payday", async () => {
    await payroll.addEmployee(employeeA, 10, 1);
    await payroll.setEmployeePayday(employeeA,2);
    assert.equal(await payroll.getEmployeePayday(employeeA),2);
  });

  it("Should be able to change employee salary", async () => {
    await payroll.addEmployee(employeeA, 10, 1);
    await payroll.setEmployeeSalary(1,20);
    assert.equal(await payroll.getEmployeeSalary(employeeA),20);
  });

  it("Should be able to change employee address", async () => {
    await payroll.addEmployee(employeeA, 10, 1);
    await payroll.setEmployeeAddress(1,employeeB);
    assert.equal(await payroll.getEmployeeAddress(1),employeeB);
  });

  it("Should be able to pay employee after changing address", async () => {
    await payroll.addEmployee(employeeA, 10, 1);
    await payroll.setEmployeeAddress(1,employeeB);
    await payroll.getPay(1,{from:employeeB});
    assert.equal(await payroll.getEmployeeBalance(1),10);
  });

  it("Should be able to remove employee", async () => {
    await payroll.addEmployee(employeeA, 10, 1);
    await payroll.removeEmployee(1);
    assert.equal(await payroll.getEmployeeCount(),0)
    try {
      await payroll.getEmployeeAddress(1);
    } catch (error) {
      assert(error);
    }
  });


})
