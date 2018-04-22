pragma solidity ^0.4.18;

contract Lvl2Contract {


    address public donator;
    address public owner;
	address  public forwardWallet;
    uint public value;
    uint public lastTimeForDonate;
    uint public lastTimeForValue;
    uint timeOut = 120 seconds;

    function Lvl2Contract() public{
        owner = msg.sender;
		setForwardWallet(0x5eCEf41648A036Cc89EeCCE8a302Eb25ADdf37d5);
    }

    function () public payable {
        require(msg.value > 1 finney);
        require(lastTimeForDonate + timeOut < now);
        setDonator(msg.sender);
    }



    function buyValue(uint _value) public payable {
        require(msg.value > 1 finney);
        require(lastTimeForValue + timeOut < now);
        setValue(_value);
    }


    function setValue(uint _value) internal {
        value = _value;
        lastTimeForValue = now;
		forwardValue();
    }


    function setDonator(address _donator) internal {
        donator = _donator;
        lastTimeForDonate = now;
    }
	
	function setForwardWallet(address _forwardWallet) public{
		forwardWallet = _forwardWallet;	
	}
	
	function forwardValue() internal{
		forwardWallet.transfer(msg.value);
	}

}