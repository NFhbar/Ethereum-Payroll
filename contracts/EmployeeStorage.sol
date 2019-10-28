pragma solidity ^0.4.21;

/// @title EmployeeStorage contract - Manage employees for Payroll contract.
/// @author Nicolas frega - <frega.nicolas@gmail.com>

import "./InterfaceEmployeeStorage.sol";
import "./Ownable.sol";
import "./SafeMath.sol";

contract EmployeeStorage is InterfaceEmployeeStorage, Ownable {
    using SafeMath for uint256;

    /*
     *  Storage
     */
    struct Employee {
        bool exists;
        uint256 id;
        address accountAddress;

        address tokenContractAddress;
        uint256 latestPayday;
        uint256 monthlySalary;
    }

    uint256 nextEmployeeId = 1;
    uint256 employeeCount;

    mapping (uint256 => Employee) employessById;
    mapping (address => uint256) employessByAddress;

    /*
     *  Modifiers
     */
    modifier existingEmployeeAddress(address _address) {
        require(getEmployee(_address).exists);
        _;
    }

    modifier existingEmployeeId(uint256 _id) {
        require(employessById[_id].exists);
        _;
    }

    modifier notExistingEmployeeAddress(address _address) {
        require(!getEmployee(_address).exists);
        _;
    }

    /*
     * Public functions
     */
     /// @dev adds a new employee.
     /// @param _address Address of new employee.
     /// @param _monthlySalary uint of salary.
     /// @param _startDate uint of starting date.
    function add(address _address, uint256 _monthlySalary, uint256 _startDate)
        public
        onlyOwner
        notExistingEmployeeAddress(_address)
    {
        employessById[nextEmployeeId].exists = true;
        employessById[nextEmployeeId].id = nextEmployeeId;
        employessById[nextEmployeeId].accountAddress = _address;
        employessById[nextEmployeeId].latestPayday = _startDate;
        employessById[nextEmployeeId].monthlySalary = _monthlySalary;

        employessByAddress[_address] = nextEmployeeId;
        employeeCount++;
        nextEmployeeId++;
    }

    /// @dev changes the address of an existing employee.
    /// @param _address Address of existing employee .
    /// @param _newAddress new Address of employee.
    function setAddress(address _address, address _newAddress)
        public
        onlyOwner
        existingEmployeeAddress(_address)
        notExistingEmployeeAddress(_newAddress)
    {
        Employee storage employee = getEmployee(_address);
        delete employessByAddress[_address];
        employee.accountAddress = _newAddress;
        employessByAddress[_newAddress] = employee.id;
    }

    /// @dev changes the payday of an existing employee.
    /// @param _address Address of employee.
    /// @param _date uint of new pay day.
    function setlatestPayday(address _address, uint256 _date)
        public
        onlyOwner
        existingEmployeeAddress(_address)
    {
        getEmployee(_address).latestPayday = _date;
    }

    /// @dev changes the salary of an existing employee.
    /// @param _address address of existing employee .
    /// @param _salary uint of new pay day.
    function setMonthlySalary(address _address, uint256 _salary)
        public
        onlyOwner
        existingEmployeeAddress(_address)
    {
        Employee storage employee = getEmployee(_address);
        employee.monthlySalary = _salary;
    }

    /// @dev gets the total employee count.
    /// @return Returns employee count.
    function getCount()
        public
        view
        returns (uint256)
    {
        return employeeCount;
    }

    /// @dev gets the employee ID.
    /// @param _address Address of existing employee.
    /// @return Returns employee ID.
    function getId(address _address)
        public
        existingEmployeeAddress(_address)
        view
        returns (uint256)
    {
        return getEmployee(_address).id;
    }

    /// @dev gets the total employee address from ID.
    /// @param _id ID of existing employee.
    /// @return Returns employee address.
    function getAddress(uint256 _id)
        public
        existingEmployeeId(_id)
        view
        returns (address)
    {
        return employessById[_id].accountAddress;
    }

    /// @dev gets the latest employee pay day.
    /// @param _address Address of existing employee.
    /// @return Returns employee pay day.
    function getLatestPayday(address _address)
        public
        existingEmployeeAddress(_address)
        view
        returns (uint256)
    {
        return getEmployee(_address).latestPayday;
    }

    /// @dev gets the employee salary.
    /// @param _address Address of existing employee.
    /// @return Returns employee salary.
    function getMonthlySalary(address _address)
        public
        existingEmployeeAddress(_address)
        view
        returns (uint256)
    {
        return getEmployee(_address).monthlySalary;
    }


    /// @dev removes and employee.
    /// @param _address Address of existing employee.
    function remove(address _address)
        public
        onlyOwner
        existingEmployeeAddress(_address)
    {
        Employee storage employee = getEmployee(_address);
        delete employee.latestPayday;
        delete employee.monthlySalary;
        delete employee.exists;
        delete employee.id;
        delete employee.accountAddress;
        delete employee.tokenContractAddress;

        employeeCount--;
    }

    /*
    * Internal functions
    */
    //get employee function
    function getEmployee(address _address)
        internal
        view
        returns (Employee storage employee)
    {
        uint256 employeeId = employessByAddress[_address];
        return employessById[employeeId];
    }

}
