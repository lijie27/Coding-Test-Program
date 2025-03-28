-- Create index to increase query speed in searching and joining.
CREATE INDEX idx_jobs_search ON jobs (
    name,
    description,
    job_category_id,
    publish_status,
    deleted     
);

SELECT 
    --Use * to select all columns from Jobs to inrease readability. 
    Jobs.*,
    JobCategories.id AS `JobCategories__id`,
    JobCategories.name AS `JobCategories__name`,
    JobCategories.sort_order AS `JobCategories__sort_order`,
    JobCategories.created_by AS `JobCategories__created_by`,
    JobCategories.created AS `JobCategories__created`,
    JobCategories.modified AS `JobCategories__modified`,
    JobCategories.deleted AS `JobCategories__deleted`,
    JobTypes.id AS `JobTypes__id`,
    JobTypes.name AS `JobTypes__name`,
    JobTypes.job_category_id AS `JobTypes__job_category_id`,
    JobTypes.sort_order AS `JobTypes__sort_order`,
    JobTypes.created_by AS `JobTypes__created_by`,
    JobTypes.created AS `JobTypes__created`,
    JobTypes.modified AS `JobTypes__modified`,
    JobTypes.deleted AS `JobTypes__deleted`

FROM jobs Jobs

-- Important INNER JOIN :
    -- Ensures only jobs with an existing category are selected.
INNER JOIN job_categories JobCategories 
    ON JobCategories.id = Jobs.job_category_id 
    AND JobCategories.deleted IS NULL

    -- Ensures only jobs with an existing type are selected.
INNER JOIN job_types JobTypes 
    ON JobTypes.id = Jobs.job_type_id 
    AND JobTypes.deleted IS NULL

-- Only keep necessary LEFT JOIN , removed 7 others redundant and duplicate.
    --This filter a person's career path for the job.
LEFT JOIN jobs_career_paths JobsCareerPaths 
    ON Jobs.id = JobsCareerPaths.job_id
LEFT JOIN affiliates CareerPaths 
    ON CareerPaths.type = 3 
    AND CareerPaths.id = JobsCareerPaths.affiliate_id 
    AND CareerPaths.deleted IS NULL

    --This filter a person's qualification for the job
LEFT JOIN jobs_req_qualifications JobsReqQualifications 
    ON Jobs.id = JobsReqQualifications.job_id
LEFT JOIN affiliates ReqQualifications 
    ON ReqQualifications.type = 2 
    AND ReqQualifications.id = JobsReqQualifications.affiliate_id 
    AND ReqQualifications.deleted IS NULL

WHERE 
-- Only keep the rows that the word "キャビンアテンダント"(Flight attendant) is likely to appear.
    (JobCategories.name LIKE '%キャビンアテンダント%' 
    OR JobTypes.name LIKE '%キャビンアテンダント%' 
    OR Jobs.name LIKE '%キャビンアテンダント%' 
    OR Jobs.description LIKE '%キャビンアテンダント%')
    AND Jobs.publish_status = 1 
    AND Jobs.deleted IS NULL

GROUP BY Jobs.id 
ORDER BY Jobs.sort_order DESC, Jobs.id DESC  
LIMIT 50 OFFSET 0;
