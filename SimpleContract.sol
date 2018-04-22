pragma solidity 0.4.20;


contract myFirstDapp {
    
    string public txt;
    
    function outputMsg(string _txt) external {
        txt = _txt;
    }
    
}