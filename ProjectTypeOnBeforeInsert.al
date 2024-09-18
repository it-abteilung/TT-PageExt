codeunit 50010 ProjectTypeOnBeforeInsertJob
{
    [EventSubscriber(ObjectType::Table, Database::Job, 'OnBeforeInitJobNo', '', false, false)]
    local procedure ProjectTypeOnBeforeInitJobNo(var IsHandled: Boolean; var Job: Record Job; var xJob: Record Job)
    var
        JobType: Record "Job Type";
        JobsSetup: Record "Jobs Setup";
        // NoSeriesMgt: Codeunit NoSeriesManagement; // "NoSeriesManagement" is now "No. Series"
        NoSeries: Codeunit "No. Series";
    begin
        Message('%1', Job."No.");
        JobsSetup.Get();
        IF Job."No." = '' THEN BEGIN
            Job.FILTERGROUP(2);
            IF PAGE.RUNMODAL(50009, JobType) = ACTION::LookupOK THEN BEGIN
                JobsSetup.TESTFIELD("Job Nos.");
                // NoSeriesMgt.InitSeries(JobsSetup."Job Nos.", xJob."No. Series", 0D, Job."No.", Job."No. Series");
                Job."No." := NoSeries.GetNextNo(JobsSetup."Job Nos.");
                Job."No." := Job."No." + '.' + COPYSTR(JobType.Code, 1, 1);
                Job."Job Type" := JobType.Code;
                Job.FILTERGROUP(0);
            END
            ELSE BEGIN
                Job.FILTERGROUP(0);
                ERROR('Verarbeitung abgebrochen!');
            END;
        END;
        IsHandled := true;
    end;
}