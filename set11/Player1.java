
// Constructor template for Player1:
//     new Player1 (String s)
//
// Interpretation: A Player object represents a member of a team.

public class Player1 implements Player {

	String name; // is the name of this player
	Boolean contract = true; // is the contract status of this player; true by default
	Boolean injured = false; // is the injured status of this player; false by default
	Boolean suspended = false; // is the suspended status of this player; false by default

	// Constructor
	// GIVEN: the name
	// RETURNS: a Player with that name

	Player1(String s) {

		this.name = s;

	}

	// Returns the name of this player.
	// Example:
	// Players.make("Gordon Wayhard").name() => "Gordon Wayhard"

	public String name() {

		return name;

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

	// If p1 and p2 are players with distinct names, then
	// p1.toString() is not the same string as p2.toString().

	@Override
	public String toString() {

		return name.toString();
	}

}
