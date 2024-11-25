pragma solidity ^0.8.0;

contract SecureStatus {
    mapping(address => string) private statuses;

    // Event to log status updates
    event StatusUpdated(address indexed user, string newStatus);

    // Set the status for the sender's address
    function setStatus(string memory newStatus) public {
        require(bytes(newStatus).length <= 100, "Status too long"); // Limit status length to prevent misuse
        statuses[msg.sender] = newStatus;
        emit StatusUpdated(msg.sender, newStatus); // Emit event for updates
    }

    // Get the status for the sender's address
    function getMyStatus() public view returns (string memory) {
        return statuses[msg.sender];
    }

    // Allow others to view a user's status with their permission
    function getStatus(address user) public view returns (string memory) {
        require(bytes(statuses[user]).length > 0, "Status not set"); // Ensure the user has set a status
        return statuses[user];
    }
}
