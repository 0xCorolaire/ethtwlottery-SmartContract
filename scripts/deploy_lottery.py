from scripts.helpful_scripts import get_account, get_contract, fund_with_link
from brownie import MappedLottery, network, config
import time

def deploy_lottery():
    account = get_account()
    lottery = MappedLottery.deploy(
        config["networks"][network.show_active()]["keyhash"],
        {"from": account},
        publish_source=config["networks"][network.show_active()].get("verify", False),
    )
    print("Deployed")
    return lottery


def start_lottery():
    account = get_account()
    lottery = MappedLottery[-1]
    starting_tx = lottery.startLottery({"from": account})
    starting_tx.wait(1)
    print("Starting done!")


def enter_lottery():
    account = get_account()
    lottery = MappedLottery[-1]
    tx = lottery.enter({"from": account, "value": "usernametest"})
    tx.wait(1)
    print("Success Entering")

def end_lottery():
    account = get_account()
    lottery = MappedLottery[-1]
    tx = fund_with_link(lottery.address)
    tx.wait(1)
    ending_transaction = lottery.endLottery({"from": account})
    ending_transaction.wait(1)
    time.sleep(180)
    print(f"{lottery.recentWinner()} wins")


def main():
    deploy_lottery()
    start_lottery()
    enter_lottery()
    end_lottery()
