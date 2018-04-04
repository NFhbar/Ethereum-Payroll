pragma solidity ^0.4.19;

contract InterfacePayroll {

    function() public payable;

    function addEmployee(address _address, uint256 _monthlySalary, uint256 _startDate) public;
    function setEmployeeAddress(uint256 _id, address _address) public;
    function setEmployeePayday(address _address, uint256 _date) public;
    function setEmployeeSalary(uint256 _id, uint256 _monthlySalary) public;

    function getEmployeeCount() public constant returns(uint256);
    function getEmployeeID(address _address) public constant returns(uint256);
    function getEmployeeAddress(uint256 _id) public constant returns(address);
    function getEmployeePayday(address _address) public constant returns(uint256);
    function getEmployeeSalary(address _address) public constant returns(uint256);
    function getEmployee(uint256 _id) public constant returns(address _address, uint256 _payday, uint256 _salary, uint256 _payed);
    function getEmployeeBalance(uint256 _id) public constant returns(uint256);
    function getTotalSupply() public constant returns(uint256);

    function removeEmployee(uint256 _id) public;

    function getPay(uint256) public;
}
