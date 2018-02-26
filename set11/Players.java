
// Players contains the static methods
// that deal with the Player interface

public class Players {

	// static factory method for creating a Player
	// GIVEN: the name
	// RETURNS: a Player with that name

	public static Player make(String s) {
		return new Player1(s);
	}
	
	// main method for testing
	
	public static void main(String[] args) {
		TestPlayer.main(args);
	}
}
