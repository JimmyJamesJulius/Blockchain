// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract SupplyChain is AccessControl {
    bytes32 public constant AUTHORIZED_ROLE = keccak256("AUTHORIZED_ROLE");

    // Struct to store shipment details
    struct Shipment {
        uint256 id;
        string description;
        string status; // e.g., "In Transit", "Delivered"
        address updatedBy; // Address of the last updater
    }

    // Mapping to store shipments by their ID
    mapping(uint256 => Shipment) public shipments;

    // Event to emit when a shipment status is updated
    event ShipmentStatusUpdated(
        uint256 indexed shipmentId,
        string status,
        address indexed updatedBy
    );

    // Constructor to set up admin
    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    // Function to add a shipment
    function addShipment(uint256 shipmentId, string calldata description) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(shipments[shipmentId].id == 0, "Shipment already exists");
        
        shipments[shipmentId] = Shipment({
            id: shipmentId,
            description: description,
            status: "Created",
            updatedBy: msg.sender
        });
    }

    // Function to update the status of a shipment
    function updateShipmentStatus(uint256 shipmentId, string calldata status) external onlyRole(AUTHORIZED_ROLE) {
        require(shipments[shipmentId].id != 0, "Shipment does not exist");

        shipments[shipmentId].status = status;
        shipments[shipmentId].updatedBy = msg.sender;

        emit ShipmentStatusUpdated(shipmentId, status, msg.sender);
    }

    // Function to view the status of a shipment
    function getShipment(uint256 shipmentId) external view returns (Shipment memory) {
        require(shipments[shipmentId].id != 0, "Shipment does not exist");
        return shipments[shipmentId];
    }

    // Function to add an authorized entity
    function addAuthorizedEntity(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(AUTHORIZED_ROLE, account);
    }

    // Function to remove an authorized entity
    function removeAuthorizedEntity(address account) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(AUTHORIZED_ROLE, account);
    }
}
