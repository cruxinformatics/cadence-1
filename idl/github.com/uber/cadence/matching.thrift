include "shared.thrift"

namespace java com.uber.cadence

struct AddDecisionTaskRequest {
  10: optional shared.WorkflowExecution execution
  20: optional shared.TaskList taskList
  30: optional i64 (js.type = "Long") scheduleId
}

struct AddActivityTaskRequest {
  10: optional shared.WorkflowExecution execution
  20: optional shared.TaskList taskList
  30: optional i64 (js.type = "Long") scheduleId
}

/**
* MatchingService API is exposed to provide support for polling from long running applications.
* Such applications are expected to have a worker which regularly polls for DecisionTask and ActivityTask.  For each
* DecisionTask, application is expected to process the history of events for that session and respond back with next
* decisions.  For each ActivityTask, application is expected to execute the actual logic for that task and respond back
* with completion or failure.
**/
service MatchingService {
  /**
  * PollForDecisionTask is called by frontend to process DecisionTask from a specific taskList.  A
  * DecisionTask is dispatched to callers for active workflow executions, with pending decisions.
  **/
  shared.PollForDecisionTaskResponse PollForDecisionTask(1: shared.PollForDecisionTaskRequest pollRequest)
    throws (
      1: shared.BadRequestError badRequestError,
      2: shared.InternalServiceError internalServiceError,
    )

  /**
  * PollForActivityTask is called by frontend to process ActivityTask from a specific taskList.  ActivityTask
  * is dispatched to callers whenever a ScheduleTask decision is made for a workflow execution.
  **/
  shared.PollForActivityTaskResponse PollForActivityTask(1: shared.PollForActivityTaskRequest pollRequest)
    throws (
      1: shared.BadRequestError badRequestError,
      2: shared.InternalServiceError internalServiceError,
    )

  /**
  * AddDecisionTask is called by the history service when a decision task is scheduled, so that it can be dispatched
  * by the MatchingEngine.
  **/
  void AddDecisionTask(1: AddDecisionTaskRequest addRequest)
    throws (
      1: shared.BadRequestError badRequestError,
      2: shared.InternalServiceError internalServiceError,
    )

  /**
  * AddActivityTask is called by the history service when a decision task is scheduled, so that it can be dispatched
  * by the MatchingEngine.
  **/
  void AddActivityTask(1: AddActivityTaskRequest addRequest)
    throws (
      1: shared.BadRequestError badRequestError,
      2: shared.InternalServiceError internalServiceError,
    )
}