
public class Players implements Player {

	String name;
	Boolean contract = true;
	Boolean injured = false;
	Boolean suspended = false;

	// Constructor

	Players(String s) {

		name = s;

	}

	// Returns the name of this player.
	// Example:
	// Players.make("Gordon Wayhard").name() => "Gordon Wayhard"

	public String name() {

		return name;

	}

	// static factory method for creating a Player
	// GIVEN: the name
	// RETURNS: a Player with that name

	public static Player make(String s) {
		return new Players(s);
	}

	// Returns true iff this player is
	// under contract, and
	// not injured, and
	// not suspended
	// Example:
	// Player gw = Players.make ("Gordon Wayhard");
	// System.out.println (gw.available()); // prints true
	// gw.changeInjuryStatus (true);
	// System.out.println (gw.available()); // prints false

	public boolean available() {

		return (contract && !injured && !suspended);

	}

	// Returns true iff this player is under contract (employed).
	// Example:
	// Player ih = Players.make ("Isaac Homas");
	// System.out.println (ih.underContract()); // prints true
	// ih.changeContractStatus (false);
	// System.out.println (ih.underContract()); // prints false
	// ih.changeContractStatus (true);
	// System.out.println (ih.underContract()); // prints true

	public boolean underContract() {

		return contract;

	}

	// Returns true iff this player is injured.

	public boolean isInjured() {

		return injured;

	}

	// Returns true iff this player is suspended.

	public boolean isSuspended() {

		return suspended;

	}

	// Changes the underContract() status of this player
	// to the specified boolean.

	public void changeContractStatus(boolean newStatus) {

		contract = newStatus;

	}

	// Changes the isInjured() status of this player
	// to the specified boolean.

	public void changeInjuryStatus(boolean newStatus) {

		injured = newStatus;

	}

	// Changes the isSuspended() status of this player
	// to the specified boolean.

	public void changeSuspendedStatus(boolean newStatus) {

		suspended = newStatus;

	}

	// If p1 and p2 are players, then p1.equals(p2) if and only if
	// p1 and p2 are the same object (i.e. (p1 == p2), p1 and p2
	// have the same name and status, and changing the status of p1
	// necessarily changes the status of p2 in the same way).

//	@Override
//	public boolean equals(Object x) {
//
//		return this == x;
//	}

	// If p is a player, then p.hashcode() always returns the same
	// value, even after the player's status is changed by calling
	// one of the last three methods listed below.

//	@Override
//	public int hashCode() {
//
//		return super.hashCode();
//
//	}

	// If p1 and p2 are players with distinct names, then
	// p1.toString() is not the same string as p2.toString().

	@Override
	public String toString() {

		return name.toString();
	}

	public static void main(String[] args) {

		Player ih = Players.make("Isaac Homas");

		Player p1 = Players.make("Player1");
		Player p2 = Players.make("Player2");
		Player p3 = Players.make("Player3");

		int pHash = p1.hashCode();

		assert ih.name() == "Isaac Homas";

		assert p1.hashCode() == pHash : "Error in hashcode";

		assert ih.underContract() == true : "Error in contract";
		ih.changeContractStatus(false);

		assert ih.underContract() == false : "Error in contract";
		ih.changeContractStatus(true);
		assert ih.underContract() == true : "Error in contract";

		p2.changeContractStatus(false);
		p2.changeInjuryStatus(false);
		p2.changeSuspendedStatus(true);

		p1.changeContractStatus(false);
		p1.changeInjuryStatus(false);
		p1.changeSuspendedStatus(false);

		assert p1.equals(p1) : "Error in equals";

		assert p1.equals(p2) == false : "Error in equals";

		assert p1.hashCode() == pHash : "Error in hashcode";

		assert p1.hashCode() != p2.hashCode() : "Error in hashcode";

		assert p1.toString() == "Player1" : "Error in toString";

		assert p3.available() : "Player3 is available";

		assert p2.available() == false : "Player2 is not available";

		assert p1.available() == false : "Player1 is not available";

		System.out.println("All tests passed!");
	}
}
