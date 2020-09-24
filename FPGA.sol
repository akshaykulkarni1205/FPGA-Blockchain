pragma solidity^0.5.10;

contract FPGASupplyChain {
    
            struct FPGA {
                string ECID;
                string UID;
                uint256 challenges;
                uint256 responses;
                //string authenticationMethod;
                string dateActivated;
                string manufacturerName;
                string dateManufactured;
                STATE fpgaState;
            }
            
            //Mapping the Struct FPGA to FPGARegister
            mapping (string => FPGA) public FPGARegister; 
            
            string vendorName;
            address vendorAddress = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
            string currentOwnerName;
            address currentAddress = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
            string currentOwnerPassword;
            string newOwnerName;
            address newOwnerAddress = 0x17F6AD8Ef982297579C203069C1DbfFE4348c372;
            string newOwnerPassword;
            
            
           enum STATE {
               
               ADDED, 
               INITIATED,
               ACCEPTED
           }
           
           STATE constant defaultState = STATE.ADDED;

        
        
        
        // Modifier for checking before the functions are executed
        modifier onlyVendor() {
            require(msg.sender == vendorAddress);
            _;
        }
        
        modifier onlyCurrentOwner() {
            require(msg.sender == currentAddress);
            _;
        }
        
        modifier onlyNewOwner() {
            require(msg.sender == newOwnerAddress);
            _;
        }
        
        modifier added(string memory _ECID) {
        require(FPGARegister[_ECID].fpgaState == STATE.ADDED, "The FPGA is not yet added in the list");
        _;
        }
        
        modifier initiated(string memory _ECID) {
            require(FPGARegister[_ECID].fpgaState == STATE.INITIATED, "The FPGA transfer has not been initiated yet");
            _;
        }
        
      // modifier such that the function is executed nly after event transferinitaited is emitted - To be Coded, working towards it
        
        
        
        // Event to be emitted after function execution
        
        event transferInitiated(address indexed currentAddress, address indexed newOwnerAddress);
        event transferComplete();
        
        function addFPGA(string memory _ECID,
                          string memory _UID,
                          uint256 _challenges,
                          uint256 _responses,
                          // string memory _authenticationMethod,
                          string memory _dateActivated,
                          string memory _manufacturerName,
                          string memory _dateManufactured,
                          STATE _fpgaState) public onlyVendor()
                          {
                             
                            FPGARegister[_ECID] = FPGA(_ECID, _UID, _challenges, _responses, _dateActivated, _manufacturerName, _dateManufactured, _fpgaState);
                              
                          }
        
        function transferOwnership(address currentAddress, string memory ECID, address newOwnerAddress, string memory currentPassword) public onlyCurrentOwner() added(ECID) {
            
            currentAddress = address(0);
            emit transferInitiated(currentAddress, newOwnerAddress);
        }
        
        function acceptOwnership(string memory ECID, address newAddress, string memory newPassword) public onlyNewOwner() initiated(ECID) {
            
            currentAddress = newOwnerAddress;
            emit transferComplete();
        } 
        
}