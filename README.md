# Flux - Version Control System made in OCaml

This project was created as a final project for "**Functional programming**" course.

Any resemblance to git is coincidental ;)

## Finished features

- `help`, `init`, `explode`
- branching: create (`branch`), delete (`del`), `checkout`, `merge`, `reset`
- commits: `stage`, `unstage`, `commit`, `cherry-pick`, `revert`
- `log`, `ll`, `graph`, `status`
- `diff`, `delta`

## Future goals

- `rebase`
- remotes
- more precise conflict marking
- `bisect`
- ...

## Config template

*~/.fluxconfig*:

```json
{
 "user": {
   "name": "",
   "email": ""
 }
}
```
