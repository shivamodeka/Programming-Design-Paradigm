
// unit tests for Player1

public class TestPlayer {

	public static void main(String[] args) {
		
		// use factory method make to create players
		Player ih = Players.make("Isaac Homas");

		Player p1 = Players.make("Player1");
		Player p2 = Players.make("Player2");
		Player p3 = Players.make("Player3");

		// hash code for p1
		int pHash = p1.hashCode();

		// test for name
		assert ih.name() == "Isaac Homas";

		assert p1.hashCode() == pHash : "Error in hashcode";

		// test for under contract
		assert ih.underContract() == true : "Error in contract";
		ih.changeContractStatus(false);

		assert ih.underContract() == false : "Error in contract";
		ih.changeContractStatus(true);
		assert ih.underContract() == true : "Error in contract";

		// change status of players
		p2.changeContractStatus(false);
		p2.changeInjuryStatus(false);
		p2.changeSuspendedStatus(true);

		p1.changeContractStatus(false);
		p1.changeInjuryStatus(false);
		p1.changeSuspendedStatus(false);

		// test for equals
		assert p1.equals(p1) : "Error in equals";

		assert p1.equals(p2) == false : "Error in equals";

		// test for hash code
		assert p1.hashCode() == pHash : "Error in hashcode";

		assert p1.hashCode() != p2.hashCode() : "Error in hashcode";

		// test for to string
		assert p1.toString() == "Player1" : "Error in toString";

		// test for available
		assert p3.available() : "Player3 is available";

		assert p2.available() == false : "Player2 is not available";

		assert p1.available() == false : "Player1 is not available";
		
		// hash code does not change after the operations
		assert p1.hashCode() == pHash : "Hash code remains the same"; 

		System.out.println("All tests passed!");

	}

}
