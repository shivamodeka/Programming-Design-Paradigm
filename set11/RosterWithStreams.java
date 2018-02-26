
// RosterWithStreams contains the static methods
// that deal with the RosterWithStream interface

public class RosterWithStreams {

	// RosterWithStreams.empty() is a static factory method that returns an
	// empty roster

	public static RosterWithStream empty() {

		return new RosterWithStream1();

	}

	// main method for testing

	public static void main(String[] args) {
		TestRosterWithStream.main(args);
	}
}
