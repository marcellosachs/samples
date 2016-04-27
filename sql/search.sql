/*
Objective :

We want to display search results for a particular search query (in this example the search query is 'to').
We are searching through notes, each of which can be quite long, so instead of returning a single result for each matching note,
we want to return a different result for every occurrence of the search query in a matching note.
Each result will include the occurrence of the search query as well as the text surrounding it within a given radius.
If an occurrence exists within the specified radius of a preceding occurrence, then we will not need to produce a search result for it (as it will be included in the result for the preceding occurrence anyways).

It is preferable to split matching notes according to the search query occurrences directly in SQL, and not in back-end or front-end code that manipulates the results from an SQL query. This is because splitting notes in the SQL allows us to most naturally limit the number of results produced for a given request, which is useful in the context of pagination.


Strategy :

Beginning with the set of all notes matching the search query (where the entire note body acts as the 'next' column) :

Produce a new set of rows where :
  * The 'result' column in each new row is the first occurrence of the search query in the 'next' column from a row produced in the previous step (surrounded by a specified radius of characters)

  * The 'next' column in that new row is all the text from the 'next' column of the previous step following what was extracted for this step's 'result' column.


Continue producing new rows like this until a step occurs where the only rows produced are duplicates (have been produced in previous steps).

*/

CREATE FUNCTION match_substring(t text) RETURNS text AS $$
  BEGIN
    RETURN substring(t from '%#"to#"%' for '#');
  END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION match_position(t text) RETURNS integer AS $$
  BEGIN
    RETURN strpos(t, match_substring(t));
  END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION length_match(t text) RETURNS integer AS $$
  BEGIN
    RETURN length(match_substring(t));
  END;
$$ LANGUAGE plpgsql;


WITH RECURSIVE rec AS (
    SELECT
      notes.id   as id,
      null       as result,
      notes.body as next

    FROM ts notes
    WHERE notes.body SIMILAR TO '%to%'

  UNION

    SELECT
      rec.id as id,
      -- text in a 100 character radius of the earliest occurence of regex in rec.next
      substring(
        rec.next
        from
          match_position(rec.next) - 100
        for 200 + length_match(rec.next)
      ) as result,

      -- everything in rec.next following what was extracted for 'result' above
      substring(
        rec.next
        from
          match_position(rec.next) + 100 + length_match(rec.next)
        for length(rec.next)
      ) as next

    FROM rec
)

SELECT rec.result FROM rec WHERE rec.result IS NOT NULL ORDER BY rec.result;