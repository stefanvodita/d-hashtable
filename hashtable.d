import std.conv;

/*
 * (string, integer) pairs
 */
struct Pair {
	string key;
	size_t val;

	this(string key, size_t val) {
		this.key = key;
		this.val = val;
	}

	string toString() {
		return "<" ~ key ~ "," ~ to!string(val) ~ ">";
	}
}

class Hashtable {
	private {
		size_t size;
		Pair[][] elems;
	}

	/*
	 * A constructor that takes the initial size of the hashtable
	 */
	this(size_t initialLength) {
		size = initialLength;
		elems.length = size;
	}

	/*
	 * A constructor that takes the initial size of the hashtable
	 */
	size_t normalizedHash(string word) {
		size_t hash = hashOf(word);
		return hash % size > 0 ? hash % size : -(hash % size);
	}

	/*
	 * Returns the size of the hashtable
	 */
	size_t length() {
		return size;
	}

	/*
	 * Add a new word to the hashtable, or increase the number of occurrences
	 */
	void add(string word) {
		size_t pos = normalizedHash(word);

		for (size_t i = 0; i < elems[pos].length; ++i) {
			if (elems[pos][i].key == word) {
				elems[pos] = elems[pos][0 .. i]
					~ [*(new Pair(word, elems[pos][i].val + 1))]
					~ elems[pos][i + 1 .. $];
				return;
			}
		}

		elems[pos] ~= [*(new Pair(word, 1))];
	}

	/*
	 * Remove the word from the hashtable;
	 * the word doesn't necessarily have to exist
	 */
	void remove(string word) {
		size_t pos = normalizedHash(word);

		for (size_t i = 0; i < elems[pos].length; ++i) {
			if (elems[pos][i].key == word) {
				elems[pos] = elems[pos][0 .. i]
					~ elems[pos][i + 1 .. $];
				return;
			}
		}
	}

	/*
	 * Return the number of occurances for the given word,
	 * or defaultValue if the word doesn't exist in the hashtable
	 */
	size_t get (string word, size_t defaultValue = 0) {
		size_t pos = normalizedHash(word);
		foreach(Pair el; elems[pos]) {
			if (el.key == word) {
				return el.val;
			}
		}
		return defaultValue;
	}

	/*
	 * Clear the table
	 */
	void clear() {
		size = 1;
		elems.length = 1;
		elems[0].length = 0;
	}

	/*
	 * Insert a (key, val) pair into the hashtable
	 */
	void put(string key, size_t val) {
		size_t pos = normalizedHash(key);
		elems[pos] ~= [*(new Pair(key, val))];
	}

	/*
	 * Resize the hashtable to any desired size
	 */
	void resize(size_t newsize) {
		Pair[][] aux = elems.dup;
		clear();

		size = newsize;
		elems.length = size;

		foreach (Pair[] pairs; aux) {
			foreach (Pair el; pairs) {
				put(el.key, el.val);
			}
		}
	}

	/*
	 * Double the size of the hashtable
	 */
	void resizeDouble() {
		resize(2 * size);
	}

	/*
	 * Halve the size of the hashtable
	 */
	void resizeHalve() {
		resize(size / 2);
	}

	string bucketToString(size_t index_bucket) {
		return to!string(elems[index_bucket]);
	}

	override string toString() {
		return to!string(elems);
	}
}
