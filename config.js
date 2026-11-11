// Public frontend settings only. The publishable key is designed for browser use.
// Never include any privileged backend credential in this browser file.
window.APP_CONFIG = {
  supabaseUrl: "",
  supabasePublishableKey: "",
  studyTitle: "[Insert faculty-approved study title]",
  studyContact: "[Insert principal investigator name and institutional email]",
  ethicsContact: "[Insert faculty ethics committee contact]",
  ethicsApproval: "[Insert approval/reference number]",
  dataRetention: "[Insert approved retention period and storage jurisdiction]",
  consentVersion: "draft-1.0",
  appVersion: "0.2.2"
};