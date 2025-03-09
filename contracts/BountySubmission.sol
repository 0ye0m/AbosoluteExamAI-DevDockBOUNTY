// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BountySubmission {
    address public owner;
    uint256 public constant BOUNTY_AMOUNT = 50000;
    uint256 public deadline;
    uint256 public submissionsLeft = 25;

    struct Submission {
        string githubUrl;
        string telegramId;
        address submitter;
    }

    Submission[] public submissions;
    mapping(address => bool) public hasSubmitted; // Prevent duplicates

    constructor(uint256 _deadline) {
        owner = msg.sender;
        deadline = _deadline;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    modifier validSubmission(string memory _githubUrl, string memory _telegramId) {
        require(bytes(_githubUrl).length > 0, "GitHub URL cannot be empty");
        require(bytes(_telegramId).length > 0, "Telegram ID cannot be empty");
        _;
    }

    function submitBounty(
        string memory _githubUrl, 
        string memory _telegramId
    ) external validSubmission(_githubUrl, _telegramId) {
        require(block.timestamp <= deadline, "Deadline passed");
        require(submissionsLeft > 0, "No submissions left");
        require(!hasSubmitted[msg.sender], "Already submitted");

        submissions.push(Submission(_githubUrl, _telegramId, msg.sender));
        hasSubmitted[msg.sender] = true;
        submissionsLeft--;
    }

    function getAllSubmissions() public view returns (Submission[] memory) {
        return submissions;
    }

    // Example owner-only function for extending deadlines
    function setDeadline(uint256 _newDeadline) external onlyOwner {
        deadline = _newDeadline;
    }
}