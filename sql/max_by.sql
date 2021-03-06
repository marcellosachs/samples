/*

OBJECTIVE :

For each school, retrieve the teacher whose classroom has completed the greatest number of activities.


STRATEGY :

1. Get number of completed activities for each teacher.
Note : school is determined using the domain of a teacher's email.

2. Get maximum number of activities completed by any individual teacher within each school.
Do this by grouping results from step 1 by school, selecting the max completed activities.

3. Attach results from 2 to info about the relevant teacher.

*/

CREATE OR REPLACE FUNCTION get_domain(t character varying(255)) RETURNS character varying(255) AS $$
  BEGIN
    RETURN lower(substring(t from (position('@' in t)+1)));
  END;
$$ LANGUAGE plpgsql;

WITH total_activities_completed_per_teacher as (SELECT
    best_domains.domain as domain,
    t.email as teacher_email,
    t.name as teacher_name,
    COUNT(DISTINCT activity_sessions.id) as activities_completed
    FROM users t
    LEFT JOIN classrooms on t.id = classrooms.teacher_id
    LEFT JOIN users s ON classrooms.code = s.classcode
    LEFT JOIN activity_sessions ON s.id = activity_sessions.user_id
    JOIN

      ( SELECT
        get_domain(t.email) as domain
        FROM users t
        WHERE t.role = 'teacher'
        AND t.email IS NOT NULL
        AND get_domain(t.email) NOT IN ('gmail.com', 'yahoo.com', 'hotmail.com', 'aol.com')
        GROUP BY get_domain(t.email)
        HAVING COUNT(DISTINCT t.id) > 2
      ) best_domains

    ON best_domains.domain = get_domain(t.email)

    WHERE activity_sessions.state = 'finished'
    GROUP BY best_domains.domain, t.email, t.name
    ORDER BY COUNT(DISTINCT activity_sessions.id) DESC
)




SELECT
  total_activities_completed_per_teacher.domain as domain,
  total_activities_completed_per_teacher.teacher_email as teacher_email,
  total_activities_completed_per_teacher.teacher_name as teacher_name,
  total_activities_completed_per_teacher.activities_completed as activities_completed

FROM
  total_activities_completed_per_teacher

JOIN
  (
    SELECT
      total_activities_completed_per_teacher.domain as domain,
      MAX(total_activities_completed_per_teacher.activities_completed) as activities_completed
    FROM
      total_activities_completed_per_teacher
    GROUP BY total_activities_completed_per_teacher.domain
  ) max_activities_completed_by_teacher_in_each_school

ON  total_activities_completed_per_teacher.domain               = max_activities_completed_by_teacher_in_each_school.domain
AND total_activities_completed_per_teacher.activities_completed = max_activities_completed_by_teacher_in_each_school.activities_completed
;