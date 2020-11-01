trigger AccountPDFCreationTrigger on Account (after update) {
    TriggerDispatcher.execute(new AccountTriggerHandler());
}