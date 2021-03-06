external exnOfError : Js.Promise.error => Js.Exn.t = "%identity";

type assignement = {
  .
  "arg": string,
  "ass": string,
};

type typ = {
  .
  "name": string,
  "ty": string,
};

type elpi = {
  .
  [@bs.meth]
  "compile":
    (
      array(
        {
          .
          "name": string,
          "content": string,
        },
      ),
      bool
    ) =>
    Js.Promise.t(array(typ)),
  [@bs.meth] "queryAll": string => Js.Promise.t(array(assignement)),
  [@bs.meth] "restart": unit => Js.Promise.t(string),
  "start": Js.Promise.t(string),
};

[@bs.new] [@bs.module "elpi-js"]
/* Logging callback */
external create :
  (
    (string, string, string) => unit,
    /* Answers callback */
    array(
      {
        .
        "arg": string,
        "ass": string,
      },
    ) =>
    unit
  ) =>
  elpi =
  "default";
/*

 let elpi = ElpiJs.create(
   (l, p, t) => { Js.log(l);Js.log(p); Js.log(t) },
   (arg, ass) => { Js.log(arg); Js.log(ass) },
 );

 elpi##compile([|{ "name":"toto.elpi", "content":"hello \"world\"." }|], Js.true_);
 elpi##queryAll("hello A.");

 */