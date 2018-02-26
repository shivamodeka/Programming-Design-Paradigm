
// Constructor template for RosterWithStream1:
//     new RosterWithStream1 ()
//
// Interpretation: the RosterWithStream1 represents a set of players.

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;

public class RosterWithStream1 implements RosterWithStream {

	// A set of players
	Set<Player> rosterSet = new HashSet<Player>();

	// Returns a roster consisting of the given player together
	// with all players on this roster.
	// Example:
	// r.with(p).with(p) => r.with(p)

	public RosterWithStream with(Player p) {

		RosterWithStream1 newRoster = new RosterWithStream1();
		newRoster.rosterSet.addAll(rosterSet);
		newRoster.rosterSet.add(p);

		return newRoster;
	}

	// Returns a roster consisting of all players on this roster
	// except for the given player.
	// Examples:
	// RosterWithStreams.empty().without(p) => RosterWithStreams.empty()
	// r.without(p).without(p) => r.without(p)

	public RosterWithStream without(Player p) {

		RosterWithStream1 newRoster = new RosterWithStream1();
		newRoster.rosterSet.addAll(rosterSet);
		newRoster.rosterSet.remove(p);

		return newRoster;

	}

	// Returns true iff the given player is on this roster.
	// Examples:
	//
	// RosterWithStreams.empty().has(p) => false
	//
	// If r is any roster, then
	//
	// r.with(p).has(p) => true
	// r.without(p).has(p) => false

	public boolean has(Player p) {
		return rosterSet.contains(p);
	}

	// Returns the number of players on this roster.
	// Examples:
	//
	// RosterWithStreams.empty().size() => 0
	//
	// If r is a roster with r.size() == n, and r.has(p) is false, then
	//
	// r.without(p).size() => n
	// r.with(p).size() => n+1
	// r.with(p).with(p).size() => n+1
	// r.with(p).without(p).size() => n

	public int size() {
		return rosterSet.size();
	}

	// Returns the number of players on this roster whose current
	// status indicates they are available.

	public int readyCount() {

		int count = (int) this.stream().filter(p -> p.available()).count();

		return count;
	}

	// Returns a roster consisting of all players on this roster
	// whose current status indicates they are available.

	public RosterWithStream readyRoster() {

		RosterWithStream1 newRoster = new RosterWithStream1();

		this.stream().filter(p -> p.available()).forEach(p -> newRoster.rosterSet.add(p));

		return newRoster;
	}

	// Returns an iterator that generates each player on this
	// roster exactly once, in alphabetical order by name.

	public Iterator<Player> iterator() {

		List<Player> sortedList = new ArrayList<Player>(rosterSet);
		Collections.sort(sortedList, new Compare());

		return sortedList.iterator();

	}

	// Returns a sequential Stream with this RosterWithStream
	// as its source.
	// The result of this method generates each player on this
	// roster exactly once, in alphabetical order by name.
	// Examples:
	//
	// RosterWithStreams.empty().stream().count() => 0
	//
	// RosterWithStreams.empty().stream().findFirst().isPresent()
	// => false
	//
	// RosterWithStreams.empty().with(p).stream().findFirst().get()
	// => p
	//
	// this.stream().distinct() => this.stream()
	//
	// this.stream().filter((Player p) -> p.available()).count()
	// => this.readyCount()

	public Stream<Player> stream() {

		List<Player> streamList = new ArrayList<Player>(rosterSet);
		Collections.sort(streamList, new Compare());

		return streamList.stream();
	}

	// If r1 and r2 are rosters of different sizes, then
	// r1.toString() is not the same string as r2.toString().

	@Override
	public String toString() {

		return rosterSet.toString();
	}

	// If r1 and r2 are rosters, then r1.equals(r2) if and only if
	// every player on roster r1 is also on roster r2, and
	// every player on roster r2 is also on roster r1.

	@Override
	public boolean equals(Object x) {

		if (x instanceof RosterWithStream) {

			Iterator<Player> it1 = ((RosterWithStream) x).iterator();
			Iterator<Player> it2 = this.iterator();
			while (it1.hasNext() && it2.hasNext()) {
				if (it1.next() != it2.next()) {
					return false;
				}
			}
			return it1.hasNext() == it2.hasNext();
		}
		return false;

	}

	// If r is a roster, then r.hashcode() always returns the same
	// value, even if r has some players whose status changes.

	@Override
	public int hashCode() {

		int hash = 0;
		for (Player p : rosterSet) {
			hash += p.hashCode();
		}
		return hash;
	}

}
